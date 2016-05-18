//
//  SSProduct.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSProduct.h"
#import "AppDelegate+plistDatabase.h"

@implementation SSProduct
@synthesize productName;
@synthesize createdDate;
@synthesize composition;
@synthesize productImage = _productImage;

#pragma mark - properties

-(void)setProductImage:(NSString *)productImage
{
    _productImage = productImage;
}

-(NSString*)productImage
{
    if (!_productImage){
        return @"product";
    } else {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        NSString *path = [app.rootPlistDatabaseBasePath stringByAppendingPathComponent:_productImage];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return path;
        } else {
            return _productImage;
        }
    }
}
#pragma mark - initialization
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        productName = [aDecoder decodeObjectForKey:@"productName"];
        createdDate = [aDecoder decodeObjectForKey:@"createdDate"];
        composition = [aDecoder decodeObjectForKey:@"composition"];
        _productImage = [aDecoder decodeObjectForKey:@"productImage"];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:productName forKey:@"productName"];
    [aCoder encodeObject:createdDate forKey:@"createdDate"];
    [aCoder encodeObject:composition forKey:@"composition"];
    [aCoder encodeObject:_productImage forKey:@"productImage"];
}


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

-(NSDictionary*)dictionaryValue
{
    NSDictionary *productDict = [[NSDictionary alloc] initWithObjectsAndKeys:self.productName, @"productName",self.createdDate, @"createdDate", self.composition, @"composition", self.productImage, @"productImage",  nil];
    return [productDict copy];
}
@end
