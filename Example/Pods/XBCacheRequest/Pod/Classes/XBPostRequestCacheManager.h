//
//  XBPostRequestCacheManager.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/14/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XBM_storageRequest.h"

@interface XBPostRequestCacheManager : NSObject
{
    
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (XBPostRequestCacheManager *)sharedInstance;

@end
