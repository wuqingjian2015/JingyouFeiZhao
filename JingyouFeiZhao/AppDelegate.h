//
//  AppDelegate.h
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString* kSSProductAddOperationNotification = @"Product.AddOperation.Com.QingjianWu.wwww";
static NSString *kSSElementChangeOperationNotification = @"Element.ChangeOperation.Com.QingjianWu.wwww";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(NSURL*)rootPlistDatabaseUrl;

-(NSDictionary*)rootPlistDatabase;
-(NSArray*)productPlistDatabase;
-(NSArray*)pricePlistDatabase;
-(NSDictionary*)priceList;
-(NSArray*)elementPlistDatabase;

-(void)saveProducts:(NSArray*)products;

@end

