//
//  UIColor+XBExtension.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/19/15.
//
//

#import "UIColor+XBExtension.h"

@implementation UIColor (XBExtension)

- (UIColor *)colorWithR:(float)r G:(float)g B:(float)b
{
    return [UIColor colorWithRed:(float)r / 255.0f green:(float)g / 255.0f blue:(float) b / 255.0f alpha:1];
}

@end
