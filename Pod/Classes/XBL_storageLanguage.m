//
//  XBL_storageLanguage.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/9/15.
//
//

#import "XBL_storageLanguage.h"
#import "XBLanguage.h"

@implementation XBL_storageLanguage

@dynamic shortname;
@dynamic name;

+ (void)addText:(NSDictionary *)item
{
    NSArray * matched = [XBL_storageLanguage getFormat:@"shortname=%@" argument:@[item[@"name"]]];
    
    XBL_storageLanguage *text = nil;
    if ([matched count] > 0)
    {
        text = [matched lastObject];
    }
    else
    {
        text  = [NSEntityDescription insertNewObjectForEntityForName:@"XBL_storageLanguage" inManagedObjectContext:[[XBLanguage sharedInstance] managedObjectContext]];
    }
    text.name = item[@"name"];
    text.shortname = item[@"shortname"];
    [[XBLanguage sharedInstance] saveContext];
}

+ (NSArray *)getFormat:(NSString *)format argument:(NSArray *)argument
{
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"XBL_storageLanguage" inManagedObjectContext:[[XBLanguage sharedInstance] managedObjectContext]];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:ed];
    
    NSPredicate *p1 = [NSPredicate predicateWithFormat:format argumentArray:argument];
    [fr setPredicate:p1];
    
    NSArray *result = [[[XBLanguage sharedInstance] managedObjectContext] executeFetchRequest:fr error:nil];
    return result;
}

+ (NSArray *)getAll
{
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"XBL_storageLanguage" inManagedObjectContext:[[XBLanguage sharedInstance] managedObjectContext]];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:ed];
    
    NSArray *result = [[[XBLanguage sharedInstance] managedObjectContext] executeFetchRequest:fr error:nil];
    return result;
}

+ (void)clean
{
    NSArray *all = [XBL_storageLanguage getAll];
    for (XBL_storageLanguage *language in all)
    {
        [[[XBLanguage sharedInstance] managedObjectContext] deleteObject:language];
    }
    [[XBLanguage sharedInstance] saveContext];
}

@end