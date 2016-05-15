//
//  AppDelegate+plistDatabase.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/15.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "AppDelegate+plistDatabase.h"
#import "SSProduct.h"

@implementation AppDelegate (plistDatabase)


-(NSURL*)rootPlistDatabaseUrl
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    NSString *path = [documentPath stringByAppendingPathComponent:@"elements.plist"];
    
    NSLog(@"%@", path);
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [NSURL URLWithString:path];
    } else {
        return [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"elements" ofType:@"plist"]];
    }
}

-(NSDictionary*)rootPlistDatabase
{
    static NSDictionary *_rootPlistDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _rootPlistDatabase = [NSDictionary dictionaryWithContentsOfFile:[[self rootPlistDatabaseUrl] path]];
    });
    return _rootPlistDatabase;
}

-(NSMutableArray*)productPlistDatabase
{
    static NSMutableArray* _productPlistDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // _productPlistDatabase = [self rootPlistDatabase][@"products"];
        NSMutableArray *arrayModle = [[NSMutableArray alloc] init];
        for (NSDictionary* prodcutDict  in [self rootPlistDatabase][@"products"]) {
            SSProduct* product = [SSProduct productWithDict:prodcutDict];
            [arrayModle addObject:product];
        }
        _productPlistDatabase = [arrayModle mutableCopy];
    });
    return _productPlistDatabase;
}

-(NSArray*)pricePlistDatabase
{
    static NSArray* _pricePlistDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _pricePlistDatabase = [self rootPlistDatabase][@"elements"];
        
    });
    return _pricePlistDatabase;
}
-(NSDictionary*)priceList
{
    static NSMutableDictionary* _priceList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary* lists = [[NSMutableDictionary alloc] init];
        for (NSDictionary* item in [self pricePlistDatabase]) {
            float cost = [item[@"cost"] floatValue];
            float quantity = [item[@"quantity"] floatValue];
            float price = cost / quantity;
            lists[item[@"elementName"]] = [NSNumber numberWithFloat:price];
        }
        _priceList = [lists mutableCopy];
    });
    return _priceList;
}

-(NSMutableArray*)elementPlistDatabase
{
    static NSMutableArray *elementList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *elements = [[NSMutableArray alloc] init];
        for (NSDictionary* dic in [self pricePlistDatabase]) {
            SSElement *element = [[SSElement alloc] initWithDict:dic];
            [elements addObject:element];
        }
        elementList = [elements mutableCopy];
    });
    return elementList;
}

-(void)saveProducts:(NSArray*)products
{
    NSMutableDictionary *root = [[self rootPlistDatabase] mutableCopy];
    NSMutableArray *productArray = [[NSMutableArray alloc] init];
    for(SSProduct *product in products ){
        NSDictionary *productDict = [[NSDictionary alloc] initWithObjectsAndKeys:product.productName, @"productName",product.createdDate, @"createdDate", product.composition, @"composition", nil];
        [productArray addObject:productDict];
    }
    root[@"products"] = [productArray copy];
    NSLog(@"%@", [self rootPlistDatabaseUrl]);
    
    if ([root writeToFile:[[self rootPlistDatabaseUrl] path] atomically:YES])
    {
        NSLog(@"save successfully.");
    } else {
        NSLog(@"failed to save to %@", [[self rootPlistDatabaseUrl] path]);
    }
}

-(void)saveChangeToDatabase
{
    NSMutableDictionary *root = [[self rootPlistDatabase] mutableCopy];
    NSMutableArray *productArray = [[NSMutableArray alloc] init];
    for(SSProduct *product in [self productPlistDatabase] ){
        NSDictionary *productDict = [[NSDictionary alloc] initWithObjectsAndKeys:product.productName, @"productName",product.createdDate, @"createdDate", product.composition, @"composition", nil];
        [productArray addObject:productDict];
    }
    root[@"products"] = [productArray copy];
    // root[@"products"] = [self productPlistDatabase];
    
    NSLog(@"%@", [self rootPlistDatabaseUrl]);
    
    if ([root writeToFile:[[self rootPlistDatabaseUrl] path] atomically:YES])
    {
        NSLog(@"save successfully.");
    } else {
        NSLog(@"failed to save to %@", [[self rootPlistDatabaseUrl] path]);
    }
}
@end
