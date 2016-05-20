//
//  SSProductTableViewController.h
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/14.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSProduct.h"


@interface SSProductTableViewController :UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) SSProduct* productToAdd;

-(void)addProduct:(SSProduct*)productToAdd;
-(BOOL)saveProducts;

@end
