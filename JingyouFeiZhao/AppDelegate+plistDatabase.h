//
//  AppDelegate+plistDatabase.h
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/15.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (plistDatabase)

-(NSURL*)rootPlistDatabaseUrl;

-(NSDictionary*)rootPlistDatabase;
-(NSMutableArray*)productPlistDatabase;
-(NSArray*)pricePlistDatabase;
-(NSDictionary*)priceList;
-(NSMutableArray*)elementPlistDatabase;

-(void)saveProducts:(NSArray*)products;
-(void)saveChangeToDatabase;
@end
