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
static NSString *kSSElementDisselectOperationNotification = @"Element.DisselectOperation.Com.QingjianWu.wwww";
static NSString *kSSElementAddOperationNotification = @"Element.AddOperation.Com.QingjianWu.wwww";

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

