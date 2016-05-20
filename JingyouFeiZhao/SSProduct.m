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
@synthesize productName = _productName;
@synthesize createdDate = _createdDate;
@synthesize composition = _composition;
@synthesize productImage = _productImage;
@synthesize productCode = _productCode;

#pragma mark - properties

-(NSString*)generateNextProductCode
{
    NSString *productCodeKey = @"globalProductCode";
    NSString *productCode = [[NSUserDefaults standardUserDefaults] objectForKey:productCodeKey];
    NSString *newProductCode = nil;
    NSString *prefix = nil;
    int count = 0;
    
    if (productCode) {
        prefix = [productCode substringToIndex:1];
        count = [[productCode substringFromIndex:1] intValue];
    } else {
        prefix = @"A";
        count = 10000;
    }
    count ++;
    newProductCode = [NSString stringWithFormat:@"%@%.5d", prefix, count];
    [[NSUserDefaults standardUserDefaults] setObject:newProductCode forKey:productCodeKey];
    
    return newProductCode;
}
-(void)setProductCode:(NSString *)productCode
{
    _productCode = productCode;
}

-(NSString*)productCode
{
    if (!_productCode || [_productCode length] == 0) {
        _productCode = [self generateNextProductCode];
    }
    return _productCode;
}

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
        _productName = [aDecoder decodeObjectForKey:@"productName"];
        _createdDate = [aDecoder decodeObjectForKey:@"createdDate"];
        _composition = [aDecoder decodeObjectForKey:@"composition"];
        _productImage = [aDecoder decodeObjectForKey:@"productImage"];
        _productCode = [aDecoder decodeObjectForKey:@"productCode"];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_productName forKey:@"productName"];
    [aCoder encodeObject:_createdDate forKey:@"createdDate"];
    [aCoder encodeObject:_composition forKey:@"composition"];
    [aCoder encodeObject:_productImage forKey:@"productImage"];
    [aCoder encodeObject:_productCode forKey:@"productCode"];
}


-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(instancetype)initWithName:(NSString*)name
{
    if (self = [super init]) {
        _productName = name;
        _createdDate = [NSDate date];
        _productImage = @"product";
        _composition = [[NSMutableArray alloc] init];
        _productCode = nil;
    }
    return self;
}

+(instancetype)productWithDict:(NSDictionary *)dict
{
    return [[SSProduct alloc] initWithDict:dict];
}

+(instancetype)productWithName:(NSString*)name
{
    return [[SSProduct alloc] initWithName:name];
}

#pragma mark - methods

-(NSDictionary*)dictionaryValue
{
    NSDictionary *productDict = [[NSDictionary alloc] initWithObjectsAndKeys:self.productName, @"productName",self.createdDate, @"createdDate", self.composition, @"composition", self.productImage, @"productImage",  self.productCode, @"productCode", nil];
    return [productDict copy];
}

-(void) addElement:(SSElement*)element
{
    if (element) {
        [self.composition addObject:element];
    }
}


-(void) addElementsFromArray:(NSArray*)array
{
    for (SSElement *element in array) {
        [self addElement:element];
    }
}
@end
