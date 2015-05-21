//
//  XBAppUtil.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 5/18/15.
//
//

#import "XBAppUtil.h"
#import <UIKit/UIKit.h>

@implementation XBAppUtil

+ (BOOL)call:(NSString *)phoneNumber
{
    NSString *phonenumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",phonenumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)callPromt:(NSString *)phoneNumber
{
    NSString *phonenumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phonenumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)openURL:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
