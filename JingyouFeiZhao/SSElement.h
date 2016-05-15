//
//  SSElement.h
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSElement : NSObject

@property (nonatomic, strong) NSString *elementName;
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSNumber *cost;
@property (nonatomic, strong) NSString *quantity_unit;

-(instancetype) initWithElement:(SSElement*)element;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)elementWithDict:(NSDictionary*)dict;

@end
