//
//  NSDictionary+XBExtension.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/19/15.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XBExtension)

+ (NSDictionary *)dictionaryWithContentsOfPlist:(NSString *)plistname;
+ (NSDictionary *)dictionaryWithContentsOfPlist:(NSString *)plistname bundleName:(NSString *)name;

@end
