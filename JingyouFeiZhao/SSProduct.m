//
//  SSProduct.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSProduct.h"

@implementation SSProduct
@synthesize productName;
@synthesize createdDate;
@synthesize composition;

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)productWithDict:(NSDictionary *)dict
{
    return [[SSProduct alloc] initWithDict:dict];
}

@end
