//
//  UIImage+Developer.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UIImage+Developer.h"

@implementation UIImage (Developer)

/**
 *  重新绘制图片
 *
 *  @param color 填充色
 *
 *  @return UIImage
 */
- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
