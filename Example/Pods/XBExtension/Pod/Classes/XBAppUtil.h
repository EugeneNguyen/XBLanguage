//
//  XBAppUtil.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/18/15.
//
//

#import <Foundation/Foundation.h>

@interface XBAppUtil : NSObject

+ (BOOL)call:(NSString *)phoneNumber;
+ (BOOL)callPromt:(NSString *)phoneNumber;
+ (BOOL)openURL:(NSString *)url;

@end
