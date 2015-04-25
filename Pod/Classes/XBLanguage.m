//
//  XBLanguage.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/9/15.
//
//

#import "XBLanguage.h"
#import "XBL_storageText.h"
#import "XBL_storageLanguage.h"
#import "JSONKit.h"
#import "XBCacheRequest.h"

static NSString * XBLanguageUpdatedLanguage = @"XBLanguageUpdatedLanguage";

static XBLanguage *__sharedLanguage = nil;

@interface XBLanguage ()

@end

@implementation XBLanguage
@synthesize host;
@synthesize language = _language;
@synthesize isDebug;

+ (XBLanguage *)sharedInstance
{
    if (!__sharedLanguage)
    {
        __sharedLanguage = [[XBLanguage alloc] init];
        __sharedLanguage.language = @"en";
    }
    return __sharedLanguage;
}

- (void)selectLanguage:(NSString *)language
{
    [self setLanguage:language];
    [[NSUserDefaults standardUserDefaults] setObject:self.language forKey:@"XBLanguageSelectedLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLanguage:(NSString *)language
{
    language = [language stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (self.isDebug) NSLog(@"[XBLanguage] set language: %@", language);
    _language = language;
}

- (void)initialWithHost:(NSString *)_host
{
    if (self.isDebug) NSLog(@"[XBLanguage] init with host: %@", _host);
    self.host = _host;
    [self initial];
}

- (void)initial
{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"XBLanguageSelectedLanguage"])
    {
        self.language = [[NSUserDefaults standardUserDefaults] stringForKey:@"XBLanguageSelectedLanguage"];
    }
    else
    {
        self.language = [[NSLocale preferredLanguages] objectAtIndex:0];
    }
    NSArray *find = [XBL_storageLanguage getFormat:@"name=%@" argument:@[self.language]];
    if ([find count] == 0)
    {
        [self suggestLanguage:self.language];
    }
    [self getVersion];
}

- (void)getVersion
{
    if (self.isDebug) NSLog(@"[XBLanguage] start get version");
    XBCacheRequest *request = XBCacheRequest([self linkForPath:@"pluslocalization/get_version"]);
    request.disableIndicator = YES;
    request.disableCache = YES;
    [request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *resultString, BOOL fromCache, NSError *error, id object) {
        
        if (object)
        {
            if (self.isDebug) NSLog(@"[XBLanguage] get version: %@", object);
        }
        else
        {
            if (self.isDebug) NSLog(@"[XBLanguage] get version: %@", request.responseString);
        }
        NSInteger recentVersion = [[NSUserDefaults standardUserDefaults] integerForKey:@"XBLanguageVersion"];
        NSInteger serverVersion = [object[@"language_version"] integerValue];
        if (recentVersion != serverVersion)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:serverVersion forKey:@"XBLanguageVersion"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self updateLanguage];
        }
    }];
}

- (void)suggestLanguage:(NSString *)__language
{
    if (self.isDebug) NSLog(@"[XBLanguage] start suggest language: %@", __language);
    
    XBCacheRequest *request = XBCacheRequest([self linkForPath:@"pluslocalization/ask_language"]);
    request.disableIndicator = YES;
    request.disableCache = YES;
    [request setDataPost:[@{@"language": __language} mutableCopy]];
    [request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *result, BOOL fromCache, NSError *error, id object) {
        if (self.isDebug) NSLog(@"[XBLanguage] suggest language: %@", result);
    }];
}

- (void)updateLanguage
{
    if (self.isDebug) NSLog(@"[XBLanguage] start update language");
    XBCacheRequest *request = XBCacheRequest([self linkForPath:@"pluslocalization/get_language_supported"]);
    request.disableIndicator = YES;
    request.disableCache = YES;
    [request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *resultString, BOOL fromCache, NSError *error, id object) {
        [XBL_storageLanguage clean];
        if (object)
        {
            if (self.isDebug)  NSLog(@"[XBLanguage] update language: %@", object);
        }
        else
        {
            if (self.isDebug) NSLog(@"[XBLanguage] update language: %@", resultString);
        }
        for (NSDictionary *item in object[@"data"])
        {
            [XBL_storageLanguage addText:@{@"shortname": item[@"name"],
                                           @"name": item[@"long_name"],
                                           @"support": item[@"support"]}];
        }
        [[NSUserDefaults standardUserDefaults] setObject:object[@"primary"] forKey:@"XBLanguagePrimaryLanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self updateText];
    }];
}

- (void)updateText
{
    if (self.isDebug) NSLog(@"[XBLanguage] start update text");
    XBCacheRequest *request = XBCacheRequest([self linkForPath:@"pluslocalization/get_list_text"]);
    request.disableCache = YES;
    request.disableIndicator = YES;
    [request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *resultString, BOOL fromCache, NSError *error, id object) {
        if (object)
        {
            if (self.isDebug) NSLog(@"[XBLanguage] update text: %@", object);
        }
        else
        {
            if (self.isDebug) NSLog(@"[XBLanguage] update text: %@", resultString);
        }
        if ([object[@"code"] intValue] == 200)
        {
            for (NSDictionary *item in object[@"data"])
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
        [[XBLanguage sharedInstance] saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:XBLanguageUpdatedLanguage object:nil];
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
    
    XBL_storageText *text = [self textFor:key screen:screen language:self.language];
    if (!text)
    {
        if (![[NSUserDefaults standardUserDefaults] stringForKey:@"XBLanguagePrimaryLanguage"])
        {
            if (self.isDebug) NSLog(@"[XBLanguage] using key for text: %@ for %@ %@ %@", NSLocalizedString(key, nil), key, screen, self.language);
            [self suggest:key screen:screen];
            return NSLocalizedString(key, nil);
        }
        
        text = [self textFor:key screen:screen language:[[NSUserDefaults standardUserDefaults] stringForKey:@"XBLanguagePrimaryLanguage"]];
        if (!text)
        {
            if (self.isDebug) NSLog(@"[XBLanguage] using key for text: %@ for %@ %@ %@", NSLocalizedString(key, nil), key, screen, self.language);
            [self suggest:key screen:screen];
            return NSLocalizedString(key, nil);
        }
        else
        {
            if (self.isDebug) NSLog(@"[XBLanguage] using primarylanguage for text: %@ for %@ %@ %@", NSLocalizedString(text.translatedText, nil), key, screen, self.language);
            return text.translatedText;
        }
    }
    else
    {
        if (self.isDebug) NSLog(@"[XBLanguage] using translated text: %@ for %@ %@ %@", text.translatedText, key, screen, self.language);
        return text.translatedText;
    }
}

- (XBL_storageText *)textFor:(NSString *)key screen:(NSString *)screen language:(NSString *)language
{
    NSArray *languages = [XBL_storageLanguage getFormat:@"shortname=%@ or support contains[cd] %@" argument:@[language, language]];
    if ([languages count] == 0)
    {
        return nil;
    }
    XBL_storageLanguage *l = [languages firstObject];
    NSArray *array = [XBL_storageText getFormat:@"text=%@ and screen=%@ and self.language=%@" argument:@[key, screen, l.shortname]];
    return [array lastObject];
}

- (void)suggest:(NSString *)key screen:(NSString *)screen
{
    XBCacheRequest *request = XBCacheRequest([self linkForPath:@"pluslocalization/add_text"]);
    request.disableIndicator = YES;
    request.disableCache = YES;
    [request setDataPost:[@{@"text": key,
                            @"screen": screen} mutableCopy]];
    [request startAsynchronousWithCallback:nil];
}

- (NSString *)linkForPath:(NSString *)path
{
    if (!host)
    {
        return path;
    }
    else
    {
        return [NSString stringWithFormat:@"%@/%@", host, path];
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
