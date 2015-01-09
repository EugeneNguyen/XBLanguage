//
//  XBL_storageText.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/9/15.
//
//

#import "XBL_storageText.h"
#import "XBLanguage.h"

@implementation XBL_storageText

@dynamic id;
@dynamic text;
@dynamic screen;
@dynamic language;
@dynamic translatedText;

+ (void)addText:(NSDictionary *)item
{
    NSArray * matched = [XBL_storageText getFormat:@"text=%@ and screen=%@ and language=%@" argument:@[item[@"text"], item[@"screen"], item[@"language"]]];
    
    XBL_storageText *text = nil;
    if ([matched count] > 0)
    {
        text = [matched lastObject];
    }
    else
    {
        text  = [NSEntityDescription insertNewObjectForEntityForName:@"XBL_storageText" inManagedObjectContext:[[XBLanguage sharedInstance] managedObjectContext]];
    }
    text.text = item[@"text"];
    text.screen = item[@"screen"];
    text.language = item[@"language"];
    text.translatedText = item[@"translatedText"];
    [[XBLanguage sharedInstance] saveContext];
}

+ (NSArray *)getFormat:(NSString *)format argument:(NSArray *)argument
{
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"XBL_storageText" inManagedObjectContext:[[XBLanguage sharedInstance] managedObjectContext]];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:ed];
    
    NSPredicate *p1 = [NSPredicate predicateWithFormat:format argumentArray:argument];
    [fr setPredicate:p1];
    
    NSArray *result = [[[XBLanguage sharedInstance] managedObjectContext] executeFetchRequest:fr error:nil];
    return result;
}

+ (NSArray *)getAll
{
    NSEntityDescription *ed = [NSEntityDescription entityForName:@"XBL_storageText" inManagedObjectContext:[[XBLanguage sharedInstance] managedObjectContext]];
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    [fr setEntity:ed];
    
    NSArray *result = [[[XBLanguage sharedInstance] managedObjectContext] executeFetchRequest:fr error:nil];
    return result;
}

@end
