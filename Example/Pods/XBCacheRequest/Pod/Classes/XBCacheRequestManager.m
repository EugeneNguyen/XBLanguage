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

+ (XBCacheRequestManager *)sharedInstance
{
    if (!__sharedCacheRequestManager)
    {
        __sharedCacheRequestManager = [[XBCacheRequestManager alloc] init];
    }
    return __sharedCacheRequestManager;
}

- (XBCacheRequest *)requestWithPath:(NSString *)path
{
    NSURL *hostUrl = [NSURL URLWithString:host];
    NSURL *fullUrl = [NSURL URLWithString:path relativeToURL:hostUrl];
    NSLog(@"%@", [fullUrl absoluteString]);
    return [XBCacheRequest requestWithURL:fullUrl];
}

@end
