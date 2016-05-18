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

-(NSString *)rootPlistDatabaseBasePath
{
    NSLog(@"base path %@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] );
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}
-(NSString *)rootPlistDatabasePath
{
    NSString *documentPath = [self rootPlistDatabaseBasePath];
    NSString *path = [documentPath stringByAppendingPathComponent:@"elements.plist"];
    
    return path;
}
-(NSURL*)rootPlistDatabaseUrl
{
    NSString  *path = [self rootPlistDatabasePath];
    NSLog(@"%@", path);
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [NSURL URLWithString:path];
    } else {
        return [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"elements" ofType:@"plist"]];
    }
}

-(NSURL*)elementV2PlistDatabaseUrl
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"elements_v2" ofType:@"plist"];
    NSString *documentPath = [[self rootPlistDatabaseBasePath] stringByAppendingPathComponent:@"elements_v2.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentPath]) {
        return [NSURL URLWithString:documentPath];
    } else {
        return [NSURL URLWithString:bundlePath];
    }
}

-(NSDictionary*)elementV2PlistDatabase
{
    static NSDictionary* _elementV2PlistDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _elementV2PlistDatabase = [NSDictionary dictionaryWithContentsOfFile:[[self elementV2PlistDatabaseUrl] path]];
    });
    return _elementV2PlistDatabase;
}
-(NSArray*)elementV2DatabaseNames
{
    static NSArray *_elementV2DatabaseNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _elementV2DatabaseNames = [[[self elementV2PlistDatabase] allKeys] copy];
    });
    return _elementV2DatabaseNames;
}

-(NSMutableArray*)jichuyouDatabase
{
    static NSMutableArray *_jichuyouDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _jichuyouDatabase =[[self elementV2PlistDatabase][@"jichuyou"] mutableCopy];
    });
    return _jichuyouDatabase;
}

-(NSMutableArray*)jingyouDatabase
{
    static NSMutableArray *_jingyouDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _jingyouDatabase =[[self elementV2PlistDatabase][@"jingyou"] mutableCopy];
    });
    return _jingyouDatabase;
}
-(NSMutableArray*)zaojiDatabase
{
    static NSMutableArray *_zaojiDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _zaojiDatabase =[[self elementV2PlistDatabase][@"zaoji"] mutableCopy];
    });
    return _zaojiDatabase;
}
-(NSMutableArray*)sesuDatabase
{
    static NSMutableArray *_sesuDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sesuDatabase =[[self elementV2PlistDatabase][@"sesu"] mutableCopy];
    });
    return _sesuDatabase;
}
-(NSMutableArray*)ganzhiwuDatabase
{
    static NSMutableArray *_ganzhiwuDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ganzhiwuDatabase =[[self elementV2PlistDatabase][@"ganzhiwu"] mutableCopy];
    });
    return _ganzhiwuDatabase;
}

-(NSMutableArray*)otherDatabase
{
    static NSMutableArray *_otherDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _otherDatabase =[[self elementV2PlistDatabase][@"other"] mutableCopy];
    });
    return _otherDatabase;
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
            SSElement *element = [SSElement elementWithDict:item];
            NSDictionary *dict = [element priceDictionaryValue];
            [lists addEntriesFromDictionary:dict];
           // lists[item[@"elementName"]] = [NSNumber numberWithFloat:price];
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
        [productArray addObject:[product dictionaryValue]];
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
        [productArray addObject:[product dictionaryValue]];
    }
    
    root[@"products"] = [productArray copy];

    NSMutableArray *elementArray = [[NSMutableArray alloc] init];
    for(SSElement *element in [self elementPlistDatabase]){
        [elementArray addObject:[element dictionaryValue]];
    }
    root[@"elements"] = [elementArray copy];
    
    if ([root writeToFile:[self rootPlistDatabasePath] atomically:YES])
    {
        NSLog(@"save successfully.");
    } else {
        NSLog(@"failed to save to %@", [[self rootPlistDatabaseUrl] path]);
    }
}
@end
