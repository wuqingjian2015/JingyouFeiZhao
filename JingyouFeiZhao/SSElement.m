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
-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        elementName = [aDecoder decodeObjectForKey:@"elementName"];
        cost = [aDecoder decodeObjectForKey:@"cost"];
        quantity = [aDecoder decodeObjectForKey:@"quantity"];
        quantity_unit = [aDecoder decodeObjectForKey:@"quantity_unit"];
    }
    return self;
}
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:elementName forKey:@"elementName"];
    [aCoder encodeObject:cost forKey:@"cost"];
    [aCoder encodeObject:quantity_unit forKey:@"quantity_unit"];
    [aCoder encodeObject:quantity forKey:@"quantity"];
}

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
