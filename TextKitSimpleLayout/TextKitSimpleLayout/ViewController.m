//
//  ViewController.m
//  TextKitLayout
//
//  Created by Jean-Luc on 14/04/2014.
//
//

#import "ViewController.h"

#import "PathImageView.h"

#define kColumnMargin 20.0

@interface ViewController ()
{
    UITextView* _textViewColumn1;
    UITextView* _textViewColumn2;
    
    PathImageView* _panImageView;
    CGPoint _gestureStartCenter;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Create the text storage
    NSAttributedString* contentString = [[NSAttributedString alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"ConspirationMilliardaires" withExtension:@"rtf"] options:@{} documentAttributes:NULL error:NULL];
    
    NSTextStorage* textStorage = [NSTextStorage new];
    [textStorage setAttributedString:contentString];
    
    // Create the Layout Manager
    NSLayoutManager* layoutManager = [NSLayoutManager new];
    layoutManager.hyphenationFactor = 0.9;
    [textStorage addLayoutManager:layoutManager];
    
    // Create the text containers and Text Views
    {
        CGRect column1Bounds = self.column1View.bounds ;
        NSTextContainer *column1TextContainer = [[NSTextContainer alloc] initWithSize:column1Bounds.size];
        [layoutManager addTextContainer:column1TextContainer];
        
        UITextView* column1TextView = [[UITextView alloc] initWithFrame:column1Bounds textContainer:column1TextContainer];
        column1TextView.backgroundColor = [UIColor whiteColor];
        column1TextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        column1TextView.translatesAutoresizingMaskIntoConstraints = YES;
        column1TextView.scrollEnabled= NO;
        
        [self.column1View addSubview:column1TextView];
        _textViewColumn1 = column1TextView;
    }
    
    {
        CGRect column2Bounds = self.column2View.bounds ;
        NSTextContainer *column2TextContainer = [[NSTextContainer alloc] initWithSize:column2Bounds.size];
        [layoutManager addTextContainer:column2TextContainer];
        
        UITextView* column2TextView = [[UITextView alloc] initWithFrame:column2Bounds textContainer:column2TextContainer];
        column2TextView.backgroundColor = [UIColor whiteColor];
        column2TextView.translatesAutoresizingMaskIntoConstraints = YES;
        column2TextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        column2TextView.scrollEnabled= NO;
        
        [self.column2View addSubview:column2TextView];
        _textViewColumn2 = column2TextView;
    }

    // Create a shape view
    {
        CGSize panImageSize = CGSizeMake(300, 400);
        CGRect panImageFrame = CGRectMake(CGRectGetMidX(self.view.bounds) - panImageSize.width / 2,
                                             CGRectGetMidY(self.view.bounds) - panImageSize.height / 2, 
                                             panImageSize.width, panImageSize.height);
        UIBezierPath* panImagePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, panImageSize.width, panImageSize.height)];
        UIImage*      panImage = [UIImage imageNamed:@"Chrysler_Building.jpg"];
        
        _panImageView = [[PathImageView alloc] initWithFrame:panImageFrame shape:panImagePath image:panImage];
        
        [self.view addSubview:_panImageView];
        
        [_panImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panShapeImage:)]];
        
        [self updateExclusionPaths];
    }
    
    // Insert an attachement after the 5th paragraph
    {
        __block NSUInteger paragraphIndex = 0;
        __block NSUInteger insertLocation = NSNotFound;
        
        [textStorage.string enumerateSubstringsInRange:NSMakeRange(0, textStorage.length) options:NSStringEnumerationByParagraphs usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            
            paragraphIndex += 1;
            if (paragraphIndex == 5)
            {
                insertLocation = NSMaxRange(enclosingRange);
                *stop = YES;
            }
        }];
        
        if (insertLocation != NSNotFound)
        {
            NSTextAttachment* textAttachment = [NSTextAttachment new];
            textAttachment.image = [UIImage imageNamed:@"Rockefeller.png"];
            textAttachment.bounds = CGRectMake(0, 0, 120, 150);
            
            [textStorage replaceCharactersInRange:NSMakeRange(insertLocation, 0) withString:@"\n"];
            [textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment] atIndex:insertLocation];
        }
    }
}

- (IBAction)setColumn1Size:(UISlider*)sender
{
    CGFloat colum1Width = (self.view.bounds.size.width - 4 * kColumnMargin) * sender.value;
    
    CGRect col1frame = self.column1View.frame;
    col1frame.size.width = colum1Width;
    self.column1View.frame = col1frame;
    
    CGRect col2Frame = self.column2View.frame;
    col2Frame.origin.x = 3 * kColumnMargin + colum1Width;
    col2Frame.size.width = self.view.bounds.size.width - (kColumnMargin + col2Frame.origin.x);
    self.column2View.frame = col2Frame;
    
    [self updateExclusionPaths];
    
}

- (void)panShapeImage:(UIPanGestureRecognizer *)panGestureRecognizer
{
	if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
		_gestureStartCenter = _panImageView.center;
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint currentTranslation = [panGestureRecognizer translationInView:self.view];
        CGPoint currentCenter;
        currentCenter.x = _gestureStartCenter.x + currentTranslation.x;
        currentCenter.y = _gestureStartCenter.y + currentTranslation.y;
        
        _panImageView.center = currentCenter;
        
        [self updateExclusionPaths];
    }
}

- (void)updateExclusionPaths
{
    // Translate the path of _panImageView into the current view coordinate system
    UIBezierPath* exclusionPath1 = [_panImageView.viewShape copy];
    CGPoint origin1 = [_textViewColumn1 convertPoint:_panImageView.bounds.origin fromView:_panImageView];
    [exclusionPath1 applyTransform:CGAffineTransformMakeTranslation(origin1.x - _textViewColumn1.textContainerInset.left,
                                                                    origin1.y - _textViewColumn1.textContainerInset.top)];
    _textViewColumn1.textContainer.exclusionPaths = @[exclusionPath1];
    
    UIBezierPath* exclusionPath2 = [_panImageView.viewShape copy];
    CGPoint origin2 = [_textViewColumn2 convertPoint:_panImageView.bounds.origin fromView:_panImageView];
    [exclusionPath2 applyTransform:CGAffineTransformMakeTranslation(origin2.x - _textViewColumn1.textContainerInset.left, 
                                                                    origin2.y - _textViewColumn1.textContainerInset.top)];
    _textViewColumn2.textContainer.exclusionPaths = @[exclusionPath2];
}

@end
