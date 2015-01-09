//
//  UILabel+xblanguage.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/9/15.
//
//

#import "UILabel+xblanguage.h"
#import "XBLanguage.h"

@implementation UILabel (xblanguage)
@dynamic screen;

- (void)setScreen:(NSString *)screen
{
    self.text = [[XBLanguage sharedInstance] stringForKey:self.text andScreen:screen];
}

@end
