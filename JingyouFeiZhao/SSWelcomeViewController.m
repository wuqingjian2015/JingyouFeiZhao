//
//  SSWelcomeViewController.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/20.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSWelcomeViewController.h"
#import "SSConstants.h"

@interface SSWelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation SSWelcomeViewController
@synthesize backgroundImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    float width = kScreenWidth;
    float height = kScreenHeight;
    
    backgroundImageView.frame = CGRectMake(0, 0, width, height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
