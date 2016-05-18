//
//  JingyouFeiZhaoTests.m
//  JingyouFeiZhaoTests
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SSElement.h"
#import "SSProduct.h"
#import "AppDelegate+plistDatabase.h"

@interface JingyouFeiZhaoTests : XCTestCase

-(void)testProductCreation;
-(void)testProductSave;
-(void)testElementSave;
-(void)testResourceCopy;

-(void)testEv2Creation;

@end

@implementation JingyouFeiZhaoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [[NSFileManager defaultManager] removeItemAtPath:[app rootPlistDatabasePath] error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void)testEv2Creation
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    XCTAssertNotNil([app elementV2PlistDatabase]);
    
    NSURL* ev2url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"elements_v2" ofType:@"plist"]];

    XCTAssertTrue([[[app elementV2PlistDatabaseUrl] path] isEqualToString: [ev2url path]]);
    
}

-(void)testResourceCopy
{
    UIImage *image = [UIImage imageNamed:@"/Users/caoli/Library/Developer/CoreSimulator/Devices/C6F1D123-EEAF-461D-AE86-FBDDC49739C1/data/Containers/Data/Application/E00C1DA1-D61C-4CB4-B314-49DF73BE2499/Documents/Element_3B8278A5-DBDA-452A-911B-05FBFA4A999A.png"];
    NSLog(@"%@", image);
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    if(![[NSFileManager defaultManager] fileExistsAtPath:[app rootPlistDatabasePath]] )
    {
        NSString *originElementsPlistPath =  [[NSBundle mainBundle] pathForResource:@"elements" ofType:@"plist"];
        NSError *error = nil;
        if(![[NSFileManager defaultManager] copyItemAtPath:originElementsPlistPath toPath:[app rootPlistDatabasePath] error:&error]){
            NSLog(@"Failed to copy resources file to %@", [app rootPlistDatabasePath]);
            // return NO;
        }
        
        NSLog(@"%@",[[NSBundle mainBundle] resourcePath]);
     
        NSLog(@"%@",[[NSBundle mainBundle] pathForResource:@"jingyou" ofType:@"png"]);
        
        NSArray *allPngs = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:[[NSBundle mainBundle] resourcePath]];
        [allPngs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@", obj);
        }];
    }
}
-(void)testElementSave
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jingyou" ofType:@"png"];
    NSString *newPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"new path %@", newPath);
    AppDelegate * app = [[UIApplication sharedApplication] delegate];
    for (SSElement *element in app.elementPlistDatabase) {
        NSLog(@"element class %@", [element class]);
        NSString *imgPath = [newPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", element.elementName]];
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:imgPath error:nil];
    }

}
-(void)testProductSave
{
    
}
-(void)testProductCreation
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"elements" ofType:@"plist"];
    NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *prodcutArray = root[@"products"];
    NSMutableArray *arrayModle = [[NSMutableArray alloc] init];
    for (NSArray* item in prodcutArray) {
        for (NSDictionary* prodcutDict in item) {
            NSMutableDictionary *pMutable = [prodcutDict mutableCopy];
            SSProduct* product = [SSProduct productWithDict:pMutable];
            [arrayModle addObject:product];
        }
    }
    

}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
