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

@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSArray *composition;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)productWithDict:(NSDictionary*)dict;

-(instancetype)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

@end
