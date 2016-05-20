//
//  SSQRCodeView.h
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/18.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSQRCodeView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

-(instancetype)initWithFrame:(CGRect)frame;

@end
