//
//  NSObject+XBExtension.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/19/15.
//
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface NSObject (XBExtension)

- (void)alert:(NSString *)title message:(NSString *)message;

- (MBProgressHUD *)showHUD:(NSString *)string;

- (void)hideHUD;

@end
