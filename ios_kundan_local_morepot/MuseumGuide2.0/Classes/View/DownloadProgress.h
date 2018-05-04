//
//  DownloadProgress.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/25.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadProgress : UIView

/**
 进度条颜色 默认红色
 */
@property (nonatomic, strong) UIColor *progressColor;

/**
 进度条背景色 默认灰色
 */
@property (nonatomic, strong) UIColor *progressBackgroundColor;

/**
 进度条宽度 默认5
 */
@property (nonatomic, assign) CGFloat progressWidth; /**< 进度条宽度 默认3*/

/**
 进度条进度
 */
@property (nonatomic, assign) float percent;

/**
 NO顺时针，YES逆时针
 */
@property (nonatomic, assign) BOOL clockwise;

/**
 中心label
 */
@property (nonatomic, strong) UILabel *centerLabel;

/**
 中心label背景色
 */
@property (nonatomic, strong) UIColor *labelbackgroundColor;

/**
 Label的字体颜色 默认黑色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 Label的字体大小 默认15
 */
@property (nonatomic, strong) UIFont *textFont;

@end

@interface LoadingCircle : UIView

@property (nonatomic,strong)DownloadProgress *downloadProgress;

@property (nonatomic,strong)UIImageView *bgImgView;

@property (nonatomic,assign)float progress;




@end





