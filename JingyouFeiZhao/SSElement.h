//
//  SSElement.h
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSElement : NSObject<NSCoding>

@property (nonatomic, strong) NSString *elementName;
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSNumber *cost;
@property (nonatomic, strong) NSString *quantity_unit;
@property (nonatomic, strong) NSString *elementImage; 




-(instancetype) initWithCoder:(NSCoder *)aDecoder;
-(void) encodeWithCoder:(NSCoder *)aCoder;

-(instancetype)initWithName:(NSString*)name quantity:(NSNumber*)aQuanity cost:(NSNumber*)aCost unit:(NSString*)aQuantity_unit image:(NSString*)imageFile;
-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)elementWithDict:(NSDictionary*)dict;

-(NSDictionary*)dictionaryValue;
-(NSDictionary*)priceDictionaryValue;

@end
