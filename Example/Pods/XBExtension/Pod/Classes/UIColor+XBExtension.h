//
//  UIColor+XBExtension.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/19/15.
//
//

#import <UIKit/UIKit.h>
#import "AVHexColor.h"

#define XBRGBColor(X, Y, Z) [UIColor colorWithR:X G:Y B:Z]
#define XBHexColor(X) [AVHexColor colorWithHexString:X]

@interface UIColor (XBExtension)

- (UIColor *)colorWithR:(float)r G:(float)g B:(float)b;

@end
