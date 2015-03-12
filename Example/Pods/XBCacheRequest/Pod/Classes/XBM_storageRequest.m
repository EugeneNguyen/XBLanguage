//
//  XBM_storageRequest.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/14/14.
//
//

#import "XBM_storageRequest.h"
#import "XBPostRequestCacheManager.h"
#import "JSONKit.h"

@implementation XBM_storageRequest

@dynamic url;
@dynamic postData;
@dynamic response;

+ (void)addCache:(NSString *)url postData:(NSDictionary *)postData response:(NSString *)response
{
    XBM_storageRequest *cache = [XBM_storageRequest getCache:url postData:postData];
    
    if (!cache)
    {
        cache  = [NSEntityDescription insertNewObjectForEntityForName:@"XBM_storageRequest" inManagedObjectContext:[[XBPostRequestCacheManager sharedInstance] managedObjectContext]];
    }
    
    cache.url = url;
    cache.postData = [postData JSONString];
    cache.response = response;
    
    [[XBPostRequestCacheManager sharedInstance] saveContext];
}

+ (XBM_storageRequest *)getCache:(NSString *)url postData:(NSDictionary *)postData
{
    if (!postData) postData = @{};
    NSString *postString = [postData JSONString];
    NSArray *result = [XBM_storageRequest getFormat:@"url=%@ and postData=%@" argument:@[url, postString]];
    if ([result count] == 0)
    {
        return nil;
    }
    return [result lastObject];
}

+ (NSArray *)getFormat:(NSString *)format argument:(NSArray *)argument
{
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"XBM_storageRequest" inManagedObjectContext:[[XBPostRequestCacheManager sharedInstance] managedObjectContext]];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:ed];
    
    NSPredicate *p1 = [NSPredicate predicateWithFormat:format argumentArray:argument];
    [fr setPredicate:p1];
    
    NSArray *result = [[[XBPostRequestCacheManager sharedInstance] managedObjectContext] executeFetchRequest:fr error:nil];
    return result;
}

+ (NSArray *)getAll
{
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"XBM_storageRequest" inManagedObjectContext:[[XBPostRequestCacheManager sharedInstance] managedObjectContext]];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:ed];
    
    NSArray *result = [[[XBPostRequestCacheManager sharedInstance] managedObjectContext] executeFetchRequest:fr error:nil];
    return result;
}

+ (void)clear
{
    NSArray *array = [XBM_storageRequest getAll];
    for (XBM_storageRequest *request in array)
    {
        [[[XBPostRequestCacheManager sharedInstance] managedObjectContext] deleteObject:request];
    }
    [[XBPostRequestCacheManager sharedInstance] saveContext];
}

@end
