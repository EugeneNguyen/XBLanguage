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
@dynamic placeHolderScreen;

- (void)setScreen:(NSString *)screen
{
    self.text = [[XBLanguage sharedInstance] stringForKey:self.text andScreen:screen];
}

- (void)setPlaceHolderScreen:(NSString *)placeHolderScreen
{
    self.placeholder = [[XBLanguage sharedInstance] stringForKey:self.placeholder andScreen:placeHolderScreen];
}

@end
