//
//  XBLanguage.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/9/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define XBText(X, Y) [[XBLanguage sharedInstance] stringForKey:X andScreen:Y]

@interface XBLanguage : NSObject
{
    
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@property (nonatomic, retain) NSString *host;
@property (nonatomic, retain) NSString *language;

+ (XBLanguage *)sharedInstance;

- (void)initialWithHost:(NSString *)_host;
- (void)updateText;
- (NSString *)stringForKey:(NSString *)key andScreen:(NSString *)screen;

@end
