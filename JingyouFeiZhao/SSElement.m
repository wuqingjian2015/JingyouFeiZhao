//
//  SSElement.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "AppDelegate+plistDatabase.h"
#import "SSElement.h"

@implementation SSElement

@synthesize elementName;
@synthesize cost;
@synthesize quantity;
@synthesize quantity_unit;
@synthesize elementImage = _elementImage;



#pragma mark -properties
-(void)setElementImage:(NSString *)elementImage
{
    _elementImage = elementImage;
}
-(NSString*)elementImage
{
    if(!_elementImage){
        return @"Jingyou";
    } else {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        
        NSString *path = [[app rootPlistDatabaseBasePath] stringByAppendingPathComponent:_elementImage];
        if([[NSFileManager defaultManager] fileExistsAtPath:path]){
            return path;
        } else {
            return _elementImage;
        }
    }
}

#pragma mark -initialization
-(instancetype)initWithName:(NSString*)name quantity:(NSNumber*)aQuanity cost:(NSNumber*)aCost unit:(NSString*)aQuantity_unit image:(NSString*)imageFile
{
    if (self = [super init]) {
        elementName = name;
        quantity = aQuanity;
        cost = aCost;
        quantity_unit = aQuantity_unit;
        _elementImage = imageFile;
    }
    return self;
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        elementName = [aDecoder decodeObjectForKey:@"elementName"];
        cost = [aDecoder decodeObjectForKey:@"cost"];
        quantity = [aDecoder decodeObjectForKey:@"quantity"];
        quantity_unit = [aDecoder decodeObjectForKey:@"quantity_unit"];
        _elementImage = [aDecoder decodeObjectForKey:@"elementImage"];
    }
    return self;
}
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:elementName forKey:@"elementName"];
    [aCoder encodeObject:cost forKey:@"cost"];
    [aCoder encodeObject:quantity_unit forKey:@"quantity_unit"];
    [aCoder encodeObject:quantity forKey:@"quantity"];
    [aCoder encodeObject:_elementImage forKey:@"elementImage"];
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

-(NSDictionary*)dictionaryValue
{
    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.elementName, @"elementName", self.quantity, @"quantity", self.cost, @"cost", self.quantity_unit, @"quantity_unit", self.elementImage, @"elementImage", nil];
    return [dic copy];
}
-(NSDictionary*)priceDictionaryValue
{
    float _cost = [self.cost floatValue];
    float _quantity = [self.quantity floatValue];
    float price = _cost / _quantity;
    
    return [[NSDictionary  dictionaryWithObject:[NSNumber numberWithFloat:price] forKey:self.elementName] copy];
}
@end
