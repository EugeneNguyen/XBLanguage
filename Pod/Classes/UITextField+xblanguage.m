//
//  UITextField+xblanguage.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/14/15.
//
//

#import "UITextField+xblanguage.h"
#import "XBLanguage.h"

@implementation UITextField (xblanguage)
@dynamic screen;

- (void)setScreen:(NSString *)screen
{
    self.text = [[XBLanguage sharedInstance] stringForKey:self.text andScreen:screen];
}

@end
