//
//  XBLanguage.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/9/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

static NSString * XBLanguageUpdatedLanguage;

#define XBText(X, Y) [[XBLanguage sharedInstance] stringForKey:X andScreen:Y]

@interface XBLanguage : NSObject
{
    
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, assign) BOOL isDebug;

- (void)saveContext;

@property (nonatomic, retain) NSString *host;
@property (nonatomic, retain) NSString *language;

+ (XBLanguage *)sharedInstance;

- (void)initialWithHost:(NSString *)_host;
- (void)initial;
- (void)updateText;
- (void)selectLanguage:(NSString *)language;
- (NSString *)stringForKey:(NSString *)key andScreen:(NSString *)screen;

@end
