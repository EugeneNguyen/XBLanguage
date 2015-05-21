//
//  XBCacheRequest.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/9/15.
//
//

#import "AFNetworking.h"
#import "XBCacheRequestManager.h"
#import "MBProgressHUD.h"

@class XBCacheRequest;
typedef enum : NSUInteger {
    XBCacheRequestTypePlain,
    XBCacheRequestTypeJSON,
    XBCacheRequestTypeXML,
} XBCacherequestResponseType;

typedef enum : NSUInteger {
    XBRestPost = 0,
    XBRestGet,
    XBRestPut,
    XBRestDelete
} XBRestMethod;

typedef void (^XBPostRequestCallback)(XBCacheRequest * request, NSString * result, BOOL fromCache, NSError * error, id object);

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
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) XBCacherequestResponseType responseType;
@property (nonatomic, assign) BOOL disableIndicator;
@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) NSMutableDictionary *files;

- (void)addFileWithURL:(NSURL *)url key:(NSString *)key;
- (void)addFileWithData:(NSData *)data key:(NSString *)key fileName:(NSString *)filename mimeType:(NSString *)mimeType;

+ (XBCacheRequest *)requestWithURL:(NSURL *)url;

- (void)setCallback:(XBPostRequestCallback)_callback;
- (void)startAsynchronousWithCallback:(XBPostRequestCallback)_callback;

+ (void)clearCache;

+ (void)rest:(XBRestMethod)method table:(NSString *)table object:(NSDictionary *)object callback:(XBPostRequestCallback)_callback;

@end
