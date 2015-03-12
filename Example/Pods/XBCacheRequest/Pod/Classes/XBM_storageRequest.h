//
//  XBM_storageRequest.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/14/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface XBM_storageRequest : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * postData;
@property (nonatomic, retain) NSString * response;

+ (void)addCache:(NSString *)url postData:(NSDictionary *)postData response:(NSString *)response;
+ (XBM_storageRequest *)getCache:(NSString *)url postData:(NSDictionary *)postData;

+ (void)clear;

@end
