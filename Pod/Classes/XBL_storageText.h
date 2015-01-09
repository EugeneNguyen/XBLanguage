//
//  XBL_storageText.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 1/9/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface XBL_storageText : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * screen;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * translatedText;

+ (void)addText:(NSDictionary *)item;
+ (NSArray *)getFormat:(NSString *)format argument:(NSArray *)argument;
+ (NSArray *)getAll;

@end
