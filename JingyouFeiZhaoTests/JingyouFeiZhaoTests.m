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
@end

@implementation JingyouFeiZhaoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
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
