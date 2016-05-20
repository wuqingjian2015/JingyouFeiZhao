//
//  SSQRCode.m
//  JingyouFeiZhao
//
//  Created by caoli on 16/5/18.
//  Copyright © 2016年 QingjianWu. All rights reserved.
//

#import "SSQRCode.h"

@implementation SSQRCode

+(UIImage*) qRCodeImageFromString:(NSString*)inputMessage withQualityLevel:(NSString*)level toFitFrame:(CGRect)frame
{
    CIImage *tempImage = [SSQRCode qRCodeImageFromString:inputMessage withQualityLevel:level];
 
    CIContext *context = [CIContext contextWithOptions:nil];

    float scaleX = frame.size.width / tempImage.extent.size.width;
    float scaleY = frame.size.height / tempImage.extent.size.height;
    
    CIImage *scaledImage = [tempImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
   
    CGImageRef imageRef = [context createCGImage:scaledImage fromRect:scaledImage.extent];

    if (tempImage) {
        return [UIImage imageWithCGImage:imageRef];
    } else {
        NSLog(@"no image file.");
        return nil;
    }
}
+(CIImage*) qRCodeImageFromString:(NSString*)inputMessage withQualityLevel:(NSString*)level
{
    NSData *dataToMake = [inputMessage dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:dataToMake forKey:@"inputMessage"];
    [filter setValue:level forKey:@"inputCorrectionLevel"];
    CIImage *result = filter.outputImage;
    filter = nil;
    return result;
}
@end
