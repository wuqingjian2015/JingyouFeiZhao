//
//  AppDelegate.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "AppDelegate.h"
#import "SSProduct.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

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

-(NSArray*)productPlistDatabase
{
    static NSArray* _productPlistDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _productPlistDatabase = [self rootPlistDatabase][@"products"];
        
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

-(NSArray*)elementPlistDatabase
{
    static NSArray *elementList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        elementList = [[self pricePlistDatabase] copy];
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


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
