//
//  DownloadProgress.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/25.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import "DownloadProgress.h"
#import  <Masonry/Masonry.h>

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation DownloadProgress
- (instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        _centerLabel = ({
            UILabel   *centerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            centerLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:centerLabel];
            centerLabel;
        });
        self.progressWidth = 5.0;
        self.progressColor = [UIColor blueColor];
        self.progressBackgroundColor = [UIColor clearColor];
        self.percent = 0.0;
        self.clockwise =0;
        self.labelbackgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)setLabelbackgroundColor:(UIColor *)labelbackgroundColor{
    _labelbackgroundColor = labelbackgroundColor;
    self.centerLabel.backgroundColor = _labelbackgroundColor;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.centerLabel.textColor = _textColor;
}

- (void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    self.centerLabel.font = _textFont;
}




- (void)layoutSubviews{
    [super layoutSubviews];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

#pragma mark -- 画进度条

- (void)drawRect:(CGRect)rect
{
    //获取当前画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, YES);
    CGContextAddArc(context, WIDTH/2, HEIGHT/2, (WIDTH-self.progressWidth)/2, 0, M_PI*2, 0);
    [self.progressBackgroundColor setStroke];//设置圆描边背景的颜色
    //画线的宽度
    CGContextSetLineWidth(context, self.progressWidth);
    //绘制路径
    CGContextStrokePath(context);
    
    if(self.percent){
        CGFloat angle = 2 * self.percent * M_PI - M_PI_2;
        if(self.clockwise) {//反方向
            CGContextAddArc(context, WIDTH/2, HEIGHT/2, (WIDTH-self.progressWidth)/2, ((int)self.percent == 1 ? -M_PI_2 : angle), -M_PI_2, 0);
        }
        else {//正方向
            CGContextAddArc(context, WIDTH/2, HEIGHT/2, (WIDTH-self.progressWidth)/2, -M_PI_2, angle, 0);
        }
        [self.progressColor setStroke];//设置圆描边的颜色
        CGContextSetLineWidth(context, self.progressWidth);
        CGContextStrokePath(context);
    }
}

- (void)setPercent:(float)percent
{
    if(self.percent < 0) return;
    _percent = percent;
    [self setNeedsDisplay];
}


@end

@implementation LoadingCircle

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _bgImgView = ({
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:imgV];
            imgV;
        });
        _downloadProgress = ({
            DownloadProgress *progress = [[DownloadProgress alloc]initWithFrame:CGRectZero];
            progress.backgroundColor = [UIColor clearColor];
            [self addSubview:progress];
            progress;
        });
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.downloadProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.masksToBounds = YES;
}


- (void)setProgress:(float)progress{
    _progress = progress;
    self.downloadProgress.percent = _progress;
}







@end



