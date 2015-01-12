//
//  UIButton+xblanguage.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/12/15.
//
//

#import "UIButton+xblanguage.h"
#import "XBLanguage.h"

@implementation UIButton (xblanguage)
@dynamic screen;

- (void)setScreen:(NSString *)screen
{
    NSString *text = [[XBLanguage sharedInstance] stringForKey:[self titleForState:UIControlStateNormal] andScreen:screen];
    [self setTitle:text forState:UIControlStateNormal];
}

@end
