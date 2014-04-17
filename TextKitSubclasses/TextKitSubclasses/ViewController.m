//
//  ViewController.m
//  TextKitSubclasses
//
//  Created by Jean-Luc Jumpertz on 15/04/2014.
//
//

#import "ViewController.h"
#import "RoundTextContainer.h"
#import "ColoringTextStorage.h"
#import "CircleTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Create the text storage
    // NSTextStorage* textstorage = [[NSTextStorage alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"TexteMultilangue" withExtension:@"rtf"] options:@{} documentAttributes:NULL error:NULL];
    
    ColoringTextStorage* textstorage = [[ColoringTextStorage alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"TexteMultilangue" withExtension:@"rtf"] options:@{} documentAttributes:NULL error:NULL];
    
    textstorage.tokensAttributes = @{ @"text" : @{ NSForegroundColorAttributeName : [UIColor redColor] },
                                      @"textkit" : @{ NSForegroundColorAttributeName : [UIColor orangeColor] },
                                      @"astérix" : @{ NSBackgroundColorAttributeName: [UIColor yellowColor]},
                                      TKDDefaultTokenName : @{ NSForegroundColorAttributeName : [UIColor blackColor],
                                                               NSBackgroundColorAttributeName: [UIColor whiteColor]}};
    
    // Create the Layout Manager
    NSLayoutManager* layoutManager = [NSLayoutManager new];
    [textstorage addLayoutManager:layoutManager];
    
    // Create the text container and Text View
    CGFloat textViewSize = fmin(self.view.bounds.size.width, self.view.bounds.size.height) * 0.8;
    CGRect textViewFrame = CGRectMake(self.view.center.x - textViewSize/2, 
                                      self.view.center.y - textViewSize/2, 
                                      textViewSize, textViewSize);
    NSTextContainer *textContainer = [[RoundTextContainer alloc] initWithSize:textViewFrame.size];
    [layoutManager addTextContainer:textContainer];
        
    UITextView* textView = [[UITextView alloc] initWithFrame:textViewFrame textContainer:textContainer];
    textView.backgroundColor = [UIColor whiteColor];
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textView.translatesAutoresizingMaskIntoConstraints = YES;
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //textView.scrollEnabled= NO;
        
    [self.view addSubview:textView];
    
    // Create and add a circle text view
    CGFloat circleViewSize = fmin(self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect circleViewFrame = CGRectMake(self.view.center.x - circleViewSize/2, 
                                        self.view.center.y - circleViewSize/2, 
                                        circleViewSize, circleViewSize);
    CircleTextView* circleTextView = [[CircleTextView alloc] initWithFrame:circleViewFrame];
    circleTextView.opaque =NO;
    circleTextView.userInteractionEnabled = NO;
    circleTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    circleTextView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.view addSubview:circleTextView];
    
    circleTextView.text = [[NSAttributedString alloc] initWithFileURL:[[NSBundle mainBundle] URLForResource:@"LigneDeTexte" withExtension:@"rtf"] options:@{} documentAttributes:NULL error:NULL];

}

@end
