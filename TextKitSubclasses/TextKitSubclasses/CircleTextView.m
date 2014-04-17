//
//  CircleTextView.m
//  TextKitSubclasses
//
//  Created by Jean-Luc Jumpertz on 15/04/2014.
//
//

#import "CircleTextView.h"

@interface CircleTextView ()
{
    NSLayoutManager* _layoutManager;
    NSTextStorage*   _textStorage;
    CGFloat _startingAngle;
}

@end

@implementation CircleTextView

- (id) initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        _startingAngle = - M_PI / 4;
    }
    return self;
}

- (void) setText:(NSAttributedString *)text
{
    if (_layoutManager == nil)
    {
        // Create the text system for this view
        _textStorage = [[NSTextStorage alloc] initWithAttributedString:text];
        _layoutManager = [NSLayoutManager new];
        [_textStorage addLayoutManager:_layoutManager];
        
        // Create a text container with infinite width
        NSTextContainer* textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(CGFLOAT_MAX, 50.0)];
        [_layoutManager addTextContainer:textContainer];
    }
    else
    {
        // Set the text storage string
        _textStorage.attributedString = text;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if ((_layoutManager != nil) && (_layoutManager.textStorage.length > 0))
    {
        
        CGRect bounds = self.bounds;
        CGFloat radius = fmin(bounds.size.width, bounds.size.height) / 2.0;
        
        NSRange glyphRange = NSMakeRange(0, 0);
        CGRect lineRect = [_layoutManager lineFragmentRectForGlyphAtIndex:0 effectiveRange:&glyphRange];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        [[UIColor clearColor] setFill];
        CGContextFillRect(ctx, bounds);
        
        // Draw every glyph on the circle
        for (NSUInteger glyphIndex = glyphRange.location; glyphIndex < NSMaxRange(glyphRange); glyphIndex += 1)
        {
            CGPoint glyphLocation = [_layoutManager locationForGlyphAtIndex:glyphIndex];
            CGFloat distance = radius - glyphLocation.y;
            CGFloat glyphAngle = _startingAngle + glyphLocation.x / distance;
            
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformTranslate(transform, radius + distance * sin(glyphAngle), 
                                                   bounds.size.height - radius + distance * cos(glyphAngle));
            transform = CGAffineTransformRotate(transform, -glyphAngle);
            
            CGContextSaveGState(ctx);
            CGContextConcatCTM(ctx, transform);
            
            [_layoutManager drawGlyphsForGlyphRange:NSMakeRange(glyphIndex, 1) 
                                            atPoint:CGPointMake(-(lineRect.origin.x + glyphLocation.x), 
                                                                -(lineRect.origin.y + glyphLocation.y))];            
            CGContextRestoreGState(ctx);
        }
    }
}

@end
