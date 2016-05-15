//
//  SSElement.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSElement.h"

@implementation SSElement

@synthesize elementName;
@synthesize cost;
@synthesize quantity;
@synthesize quantity_unit;

/*
-(instancetype) initWithElement:(SSElement*)element
{
    if (self = [super init]) {
        self.elementName = [element.elementName copy];
        self.quantity = [element.quantity copy];
        self.quantity_unit = [element.quantity_unit copy];
        self.cost = [element.cost copy];
    }
    return self;
}
 */
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype) elementWithDict:(NSDictionary *)dict
{
    return [[SSElement alloc] initWithDict:dict];
}

@end
