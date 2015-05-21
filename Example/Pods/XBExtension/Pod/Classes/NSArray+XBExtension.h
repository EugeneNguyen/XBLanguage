//
//  NSArray+XBExtension.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/19/15.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (XBExtension)

+ (NSArray *)arrayWithContentsOfPlist:(NSString *)plistname;
+ (NSArray *)arrayWithContentsOfPlist:(NSString *)plistname bundleName:(NSString *)name;

@end
