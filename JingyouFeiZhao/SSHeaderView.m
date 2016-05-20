//
//  SSHeaderView.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/19.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSHeaderView.h"
#import "SSConstants.h"

@implementation SSHeaderView
- (IBAction)changeProductName:(id)sender {
    
    NSDictionary *userInfo = @{@"changedName" : self.titleTextField.text};
    if ([self.titleTextField.text length] > 0) {
           [[NSNotificationCenter defaultCenter] postNotificationName:kSSProductChangeNameOperationNotification object:nil userInfo:userInfo];
    }
}
- (IBAction)dismissKeyboard:(id)sender {
    [self.titleTextField resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
