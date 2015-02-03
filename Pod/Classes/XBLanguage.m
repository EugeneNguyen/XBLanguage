//
//  XBLanguage.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/9/15.
//
//

#import "XBLanguage.h"
#import "ASIFormDataRequest.h"
#import "XBL_storageText.h"
#import "XBL_storageLanguage.h"
#import "JSONKit.h"
#define XBLanguageService(X) [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/pluslocalization/%@", host, X]]]

static XBLanguage *__sharedLanguage = nil;

@interface XBLanguage () <ASIHTTPRequestDelegate>

@end

@implementation XBLanguage
@synthesize host;
@synthesize language = _language;

+ (XBLanguage *)sharedInstance
{
    if (!__sharedLanguage)
    {
        __sharedLanguage = [[XBLanguage alloc] init];
        __sharedLanguage.language = @"en";
    }
    return __sharedLanguage;
}

- (void)setLanguage:(NSString *)language
{
    _language = language;
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"XBLanguageSelectedLanguage"];
}

- (void)initialWithHost:(NSString *)_host
{
    self.host = _host;
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"XBLanguageSelectedLanguage"])
    {
        self.language = [[NSUserDefaults standardUserDefaults] stringForKey:@"XBLanguageSelectedLanguage"];
        NSArray *find = [XBL_storageLanguage getFormat:@"name=%@" argument:@[self.language]];
        if (find == 0)
        {
            self.language = [[NSUserDefaults standardUserDefaults] stringForKey:@"XBLanguagePrimaryLanguage"];
        }
    }
    else
    {
        NSString * __language = [[NSLocale preferredLanguages] objectAtIndex:0];
        [self suggestLanguage:__language];
    }
    [self getVersion];
}

- (void)getVersion
{
    ASIFormDataRequest *request = XBLanguageService(@"get_version");
    [request startAsynchronous];
    
    __block ASIFormDataRequest *_request = request;
    [request setCompletionBlock:^{
        NSLog(@"%@", _request.responseString);
        NSDictionary *result = [_request.responseString mutableObjectFromJSONString];
        NSInteger recentVersion = [[NSUserDefaults standardUserDefaults] integerForKey:@"XBLanguageVersion"];
        NSInteger serverVersion = [result[@"language_version"] integerValue];
        if (recentVersion != serverVersion)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:serverVersion forKey:@"XBLanguageVersion"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self updateText];
            [self updateLanguage];
        }
    }];
}

- (void)suggestLanguage:(NSString *)__language
{
    ASIFormDataRequest *request = XBLanguageService(@"ask_language");
    [request setPostValue:__language forKey:@"language"];
    [request startAsynchronous];
}

- (void)updateLanguage
{
    ASIFormDataRequest *request = XBLanguageService(@"get_language_supported");
    [request startAsynchronous];
    
    __block ASIFormDataRequest *_request = request;
    [request setCompletionBlock:^{
        [XBL_storageLanguage clean];
        NSDictionary *result = [_request.responseString objectFromJSONString];
        for (NSDictionary *item in result[@"data"])
        {
            [XBL_storageLanguage addText:@{@"shortname": item[@"name"],
                                           @"name": item[@"long_name"]}];
        }
        [[NSUserDefaults standardUserDefaults] setObject:result[@"primary"] forKey:@"XBLanguagePrimaryLanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

- (void)updateText
{
    ASIFormDataRequest *request = XBLanguageService(@"get_list_text");
    [request startAsynchronous];
    
    __block ASIFormDataRequest *_request = request;
    [request setCompletionBlock:^{
        NSDictionary *result = [_request.responseString mutableObjectFromJSONString];
        if ([result[@"code"] intValue] == 200)
        {
            for (NSDictionary *item in result[@"data"])
            {
                NSMutableDictionary *mutableItem = [item mutableCopy];
                NSString *text = mutableItem[@"keyname"];
                NSString *screen = mutableItem[@"screen"];
                [mutableItem removeObjectsForKeys:@[@"keyname", @"screen"]];
                for (NSString *key in [mutableItem allKeys])
                {
                    [XBL_storageText addText:@{@"text": text,
                                               @"screen": screen,
                                               @"language": key,
                                               @"translatedText": mutableItem[key]}];
                }
            }
        }
    }];
}

- (NSString *)stringForKey:(NSString *)key andScreen:(NSString *)screen
{
    if (!self.language)
    {
        return key;
    }
    if (screen == nil)
    {
        screen = @"default";
    }
    NSArray *array = [XBL_storageText getFormat:@"text=%@ and screen=%@ and language=%@" argument:@[key, screen, _language]];
    if ([array count] == 0)
    {
        ASIFormDataRequest *request = XBLanguageService(@"add_text");
        [request addPostValue:key forKey:@"text"];
        [request addPostValue:screen forKey:@"screen"];
        [request startAsynchronous];
        
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"XBLanguagePrimaryLanguage"])
        {
            array = [XBL_storageText getFormat:@"text=%@ and screen=%@ and language=%@" argument:@[key, screen, [[NSUserDefaults standardUserDefaults] stringForKey:@"XBLanguagePrimaryLanguage"]]];
            if ([array count] != 0)
            {
                XBL_storageText *text = [array lastObject];
                return text.translatedText;
            }
        }
        
        return NSLocalizedString(key, nil);
    }
    else
    {
        XBL_storageText *text = [array lastObject];
        return text.translatedText;
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.libreteam._9closets" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"XBLanguage" ofType:@"bundle"]];
    NSURL *modelURL = [bundle URLForResource:@"XBLanguage" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XBLanguage.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
