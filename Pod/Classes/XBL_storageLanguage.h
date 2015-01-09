//
//  XBL_storageLanguage.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/9/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface XBL_storageLanguage : NSManagedObject

@property (nonatomic, retain) NSString * shortname;
@property (nonatomic, retain) NSString * name;

+ (void)addText:(NSDictionary *)item;
+ (NSArray *)getFormat:(NSString *)format argument:(NSArray *)argument;
+ (NSArray *)getAll;

+ (void)clean;

@end
