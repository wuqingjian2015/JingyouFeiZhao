//
//  SSAboutViewController.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/16.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSAboutViewController.h"
@interface SSAboutViewController()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SSAboutViewController
@synthesize webView;

-(void)viewDidLoad
{
    NSString *aboutPath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];

    NSString *aboutHtml = [NSString stringWithContentsOfFile:aboutPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *basePathUrl = [[NSBundle mainBundle] resourceURL];
    [self.webView loadHTMLString:aboutHtml baseURL:basePathUrl];
}
@end
