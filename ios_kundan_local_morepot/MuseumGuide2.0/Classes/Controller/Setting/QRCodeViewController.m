//
//  QRCodeViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/8/22.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()
@property (nonatomic,strong)UIImageView *imgView;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0x202126);
    _imgView = ({
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:imgView];
        imgView;
    });
    self.imgView.image = [self qrCodeWithString:self.encodeMsg];
    if (IPHONE_DEVICE) {
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
            make.leftMargin.equalTo(@60);
            make.rightMargin.equalTo(@-60);
            make.height.equalTo(self.imgView.mas_width);
        }];
    }else{
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(@200);
            make.height.equalTo(self.imgView.mas_width);
        }];
    }

    [self setBackTitle:[TXSakuraManager tx_stringWithPath:@"my_qrcode"]];
}

-(UIImage *)qrCodeWithString:(NSString *)message{
    /**
     *  2.生成CIFilter(滤镜)对象
     */
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    /**
     *  3.恢复滤镜默认设置
     */
    [filter setDefaults];
    
    /**
     *  4.设置数据(通过滤镜对象的KVC)
     */
    //存放的信息
    //把信息转化为NSData
    NSData *infoData = [message dataUsingEncoding:NSUTF8StringEncoding];
    //滤镜对象kvc存值
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    /**
     *  5.生成二维码
     */
    CIImage *outImage = [filter outputImage];
    
    return [self createNonInterpolatedUIImageFormCIImage:outImage withSize:300];
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度以及高度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
