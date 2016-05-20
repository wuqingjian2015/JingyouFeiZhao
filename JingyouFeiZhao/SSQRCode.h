//
//  SSQRCode.h
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/18.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SSQRCode : NSObject

+(UIImage*) qRCodeImageFromString:(NSString*)inputMessage withQualityLevel:(NSString*)level toFitFrame:(CGRect)frame;
+(CIImage*) qRCodeImageFromString:(NSString*)inputMessage withQualityLevel:(NSString*)level;
@end
