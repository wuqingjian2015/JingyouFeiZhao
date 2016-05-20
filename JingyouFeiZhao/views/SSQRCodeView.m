//
//  SSQRCodeView.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/18.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSQRCodeView.h"

@implementation SSQRCodeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ;
    }
    return self;
}
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
