//
//  PathImageView.m
//  TextKitLayout
//
//  Created by Jean-Luc on 14/04/2014.
//
//

#import "PathImageView.h"
@interface PathImageView ()
{
    UIBezierPath* _viewShape;
    UIImage*      _viewImage;
}
@end

@implementation PathImageView

- (id)initWithFrame:(CGRect)frame shape:(UIBezierPath*)shape image:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.opaque = NO;
        _viewShape = shape;
        _viewImage = image;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    [_viewShape addClip];
    [_viewImage drawInRect:self.bounds];
    CGContextRestoreGState(ctx);
    
    [self.tintColor setStroke];
    [_viewShape stroke];
}

@end
