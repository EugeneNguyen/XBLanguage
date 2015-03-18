//
//  XBCacheRequest.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/9/15.
//
//

#import "XBCacheRequest.h"
#import "XBM_storageRequest.h"
#import "JSONKit.h"
#import "NSObject+deepCopy.h"

@implementation XBCacheRequest
@synthesize dataPost = _dataPost, cacheDelegate, disableCache, url;
@synthesize isRunning;
@synthesize responseType;

+ (XBCacheRequest *)requestWithURL:(NSURL *)url
{
    XBCacheRequest *request = [[XBCacheRequest alloc] init];
    request.url = [url absoluteString];
    request.responseType = XBCacheRequestTypeJSON;
    return request;
}

- (void)setCallback:(XBPostRequestCallback)_callback
{
    callback = _callback;
}

- (void)startAsynchronousWithCallback:(XBPostRequestCallback)_callback
{
    [self setCallback:_callback];
    
    if (!disableCache)
    {
        XBM_storageRequest *cache = [XBM_storageRequest getCache:self.url postData:_dataPost];
        if (cache)
        {
            if ([XBCacheRequestManager sharedInstance].callback)
            {
                XBCacheRequestPreProcessor preprocessor = [XBCacheRequestManager sharedInstance].callback;
                id object = nil;
                switch (responseType) {
                    case XBCacheRequestTypeXML:
                        
                        break;
                    case XBCacheRequestTypeJSON:
                        object = [cache.response objectFromJSONString];
                        break;
                        
                    default:
                        break;
                }
                if (preprocessor(self, cache.response, YES, nil, object))
                {
                    if (callback) callback(self, cache.response, YES, nil, object);
                }
            }
            if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(requestFinishedWithString:)])
            {
                [cacheDelegate requestFinishedWithString:cache.response];
            }
            if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(request:finishedWithString:)])
            {
                [cacheDelegate request:self finishedWithString:cache.response];
            }
        }
    }
    
    isRunning = YES;
    AFHTTPRequestOperation *request = [[AFHTTPRequestOperationManager manager] POST:self.url parameters:_dataPost success:^(AFHTTPRequestOperation *operation, id responseObject) {
        isRunning = NO;
        [XBM_storageRequest addCache:url postData:_dataPost response:operation.responseString];
        if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(requestFinished:)])
        {
            [cacheDelegate requestFinished:(XBCacheRequest *)operation];
        }
        if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(requestFinishedWithString:)])
        {
            [cacheDelegate requestFinishedWithString:operation.responseString];
        }
        if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(request:finishedWithString:)])
        {
            [cacheDelegate request:self finishedWithString:operation.responseString];
        }
        
        if (responseObject)
        {
            responseObject = [responseObject deepMutableCopy];
        }
        
        if ([XBCacheRequestManager sharedInstance].callback)
        {
            XBCacheRequestPreProcessor preprocessor = [XBCacheRequestManager sharedInstance].callback;
            if (preprocessor(self, operation.responseString, NO, nil, responseObject))
            {
                if (callback) callback(self, operation.responseString, NO, nil, responseObject);
            }
        }
        else
        {
            if (callback) callback(self, operation.responseString, NO, nil, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        isRunning = NO;
        if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(requestFailed:)])
        {
            [cacheDelegate requestFailed:(XBCacheRequest *)operation];
        }
        
        if ([XBCacheRequestManager sharedInstance].callback)
        {
            XBCacheRequestPreProcessor preprocessor = [XBCacheRequestManager sharedInstance].callback;
            if (preprocessor(self, nil, NO, error, nil))
            {
                if (callback) callback(self, nil, NO, error, nil);
            }
        }
        else
        {
            if (callback) callback(self, nil, NO, error, nil);
        }
    }];
    switch (responseType) {
        case XBCacheRequestTypeJSON:
            [request setResponseSerializer:[AFJSONResponseSerializer serializer]];
            break;
            
        case XBCacheRequestTypeXML:
            [request setResponseSerializer:[AFXMLParserResponseSerializer serializer]];
            break;
            
        default:
            [request setResponseSerializer:[AFCompoundResponseSerializer serializer]];
            break;
    }
    request.responseSerializer.acceptableContentTypes = [request.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/json", @"text/javascript", @"application/json", @"text/html"]];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        disableCache = NO;
    }
    return self;
}

+ (void)clearCache
{
    [XBM_storageRequest clear];
}

@end
