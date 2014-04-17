//
//  RoundTextContainer.m
//  TextKitSubclasses
//
//  Created by Jean-Luc Jumpertz on 15/04/2014.
//
//

#import "RoundTextContainer.h"

@implementation RoundTextContainer
{
    CGSize _circleSize;
}

- (id) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self != nil)
    {
        _circleSize = size;
    }
    return self;
}

- (CGRect)lineFragmentRectForProposedRect:(CGRect)proposedRect atIndex:(NSUInteger)characterIndex writingDirection:(NSWritingDirection)baseWritingDirection remainingRect:(CGRect *)remainingRect
{
    // Call super
    CGRect baseFragmentRect = [super lineFragmentRectForProposedRect:proposedRect atIndex:characterIndex writingDirection:baseWritingDirection remainingRect:remainingRect];
    
    // Do some math to adjust the default rect
    CGFloat radius = fmin(_circleSize.width, _circleSize.height) / 2.0;
    CGFloat ypos = fabs((baseFragmentRect.origin.y + baseFragmentRect.size.height / 2.0) - radius);
    CGFloat width = (ypos < radius) ? 2.0 * sqrt(radius * radius - ypos * ypos) : 0.0;
    CGFloat originX = radius - width / 2.0;
    
    if (baseFragmentRect.origin.x > originX)
    {
        width -= baseFragmentRect.origin.x - originX;
        originX = baseFragmentRect.origin.x;
    }
    
    return CGRectMake(originX, baseFragmentRect.origin.y, width, baseFragmentRect.size.height);;
}

@end
