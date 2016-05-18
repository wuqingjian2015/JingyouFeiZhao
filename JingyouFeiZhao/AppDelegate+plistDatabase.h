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
-(NSString *)rootPlistDatabasePath;

-(NSString *)rootPlistDatabaseBasePath;
-(NSDictionary*)rootPlistDatabase;
-(NSMutableArray*)productPlistDatabase;
-(NSArray*)pricePlistDatabase;
-(NSDictionary*)priceList;
-(NSMutableArray*)elementPlistDatabase;

-(NSDictionary*)elementV2PlistDatabase;
-(NSURL*)elementV2PlistDatabaseUrl;
-(NSArray*)elementV2DatabaseNames; 
-(NSMutableArray*)jichuyouDatabase;
-(NSMutableArray*)jingyouDatabase;
-(NSMutableArray*)zaojiDatabase;
-(NSMutableArray*)sesuDatabase;
-(NSMutableArray*)ganzhiwuDatabase;
-(NSMutableArray*)otherDatabase;


-(void)saveProducts:(NSArray*)products;
-(void)saveChangeToDatabase;
@end
