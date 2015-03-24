//
//  XBCacheRequestManager.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/17/15.
//
//

#import "XBCacheRequestManager.h"
#import "XBCacheRequest.h"

static XBCacheRequestManager *__sharedCacheRequestManager = nil;

@implementation XBCacheRequestManager
@synthesize host;
@synthesize enablePlusIgniter;
@synthesize callback;
@synthesize numberOfRequest;

+ (XBCacheRequestManager *)sharedInstance
{
    if (!__sharedCacheRequestManager)
    {
        __sharedCacheRequestManager = [[XBCacheRequestManager alloc] init];
        __sharedCacheRequestManager.numberOfRequest = 0;
    }
    return __sharedCacheRequestManager;
}

- (XBCacheRequest *)requestWithPath:(NSString *)path
{
    NSURL *hostUrl = [NSURL URLWithString:host];
    NSURL *fullUrl = [NSURL URLWithString:path relativeToURL:hostUrl];
    return [XBCacheRequest requestWithURL:fullUrl];
}

+ (void)showIndicator
{
    __sharedCacheRequestManager.numberOfRequest ++;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

+ (void)hideIndicator
{
    __sharedCacheRequestManager.numberOfRequest --;
    __sharedCacheRequestManager.numberOfRequest = MAX(0, __sharedCacheRequestManager.numberOfRequest);
    if (__sharedCacheRequestManager.numberOfRequest == 0)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

@end
