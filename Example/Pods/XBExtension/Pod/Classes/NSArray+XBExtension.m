//
//  NSArray+XBExtension.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/19/15.
//
//

#import "NSArray+XBExtension.h"

@implementation NSArray (XBExtension)

+ (NSArray *)arrayWithContentsOfPlist:(NSString *)plistname
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistname ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

+ (NSArray *)arrayWithContentsOfPlist:(NSString *)plistname bundleName:(NSString *)name
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:plistname ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

@end
