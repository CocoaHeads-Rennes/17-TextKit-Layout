//
//  ColoringTextStorage.m
//  TextKitSubclasses
//
//  Created by Jean-Luc Jumpertz on 15/04/2014.
//
//

#import "ColoringTextStorage.h"

NSString *const TKDDefaultTokenName = @"TKDDefaultTokenName";

@interface ColoringTextStorage ()
{
    NSMutableAttributedString *_backingStore;
    BOOL _dynamicTextNeedsUpdate;
}

@end

@implementation ColoringTextStorage

- (id)init
{
    self = [super init];
    if (self) {
        _backingStore = [[NSMutableAttributedString alloc] init];
    }
    return self;
}

// Define required methods from NSAttributedString

- (NSString *)string
{
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location effectiveRange:range];
}

// Define required methods from NSMutableAttributedString

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    _dynamicTextNeedsUpdate = YES;
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

// Define custom behavior for this NSTextStorage

-(void)processEditing
{
    if(_dynamicTextNeedsUpdate)
    {
        _dynamicTextNeedsUpdate = NO;
        [self performReplacementsForCharacterChangeInRange:[self editedRange]];
    }
    [super processEditing];
}

// Internal methods

- (void)performReplacementsForCharacterChangeInRange:(NSRange)changedRange
{
    if (_tokensAttributes != nil)
    {
        NSRange extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
        extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
        
        NSDictionary *defaultAttributes = self.tokensAttributes [TKDDefaultTokenName];
        
        [[_backingStore string] enumerateSubstringsInRange:extendedRange options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            
            NSDictionary *attributesForToken = self.tokensAttributes [[substring lowercaseString]];
            if(!attributesForToken)
                attributesForToken = defaultAttributes;
            
            if(attributesForToken)
                [self addAttributes:attributesForToken range:substringRange];
        }];
    }
}

- (void) setTokensAttributes:(NSDictionary *)tokensAttributes
{
    _tokensAttributes = [tokensAttributes copy];
    
    [self performReplacementsForCharacterChangeInRange:NSMakeRange(0, _backingStore.length)];
}

@end
