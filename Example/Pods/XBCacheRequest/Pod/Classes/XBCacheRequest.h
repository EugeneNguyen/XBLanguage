//
//  XBCacheRequest.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/9/15.
//
//

#import "AFNetworking.h"

@class XBCacheRequest;

typedef void (^XBPostRequestCallback)(XBCacheRequest * request, NSString * result, BOOL fromCache, NSError * error);

@protocol XBCacheRequestDelegate <NSObject>

@optional

- (void)requestFinished:(XBCacheRequest *)request;
- (void)requestFailed:(XBCacheRequest *)request;
- (void)requestFinishedWithString:(NSString *)result;
- (void)request:(XBCacheRequest *)request finishedWithString:(NSString *)result;

@end

@interface XBCacheRequest : AFHTTPRequestOperation
{
    XBPostRequestCallback callback;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSMutableDictionary *dataPost;
@property (nonatomic, assign) id <XBCacheRequestDelegate> cacheDelegate;
@property (nonatomic, assign) BOOL disableCache;

+ (XBCacheRequest *)requestWithURL:(NSURL *)url;

- (void)setCallback:(XBPostRequestCallback)_callback;
- (void)startAsynchronousWithCallback:(XBPostRequestCallback)_callback;

+ (void)clearCache;

@end
