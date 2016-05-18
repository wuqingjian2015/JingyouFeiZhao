//
//  SSProduct.h
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSElement.h"

@interface SSProduct : NSObject <NSCoding>

@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSDate *createdDate;
@property (nonatomic, copy) NSMutableArray *composition;
@property (nonatomic, copy) NSString *productImage;

-(instancetype)initWithName:(NSString*)name;
-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)productWithDict:(NSDictionary*)dict;
+(instancetype)productWithName:(NSString*)name;

-(instancetype)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

-(NSDictionary*)dictionaryValue;

-(void) addElement:(SSElement*)element;
-(void) addElementsFromArray:(NSArray*)array;

@end
