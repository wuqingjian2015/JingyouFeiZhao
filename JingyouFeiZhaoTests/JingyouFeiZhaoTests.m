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

@interface JingyouFeiZhaoTests : XCTestCase

-(void)testProductCreation;
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
