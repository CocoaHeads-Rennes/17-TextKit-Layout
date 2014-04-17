//
//  ColoringTextStorage.h
//  TextKitSubclasses
//
//  Created by Jean-Luc Jumpertz on 15/04/2014.
//
//

#import <UIKit/UIKit.h>

NSString *const TKDDefaultTokenName;

@interface ColoringTextStorage : NSTextStorage

@property (nonatomic, copy) NSDictionary *tokensAttributes;

@end
