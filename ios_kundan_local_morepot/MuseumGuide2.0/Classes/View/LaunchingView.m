//
//  LaunchingView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/5/15.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import "LaunchingView.h"
#import <Masonry/Masonry.h>

@implementation LaunchingView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _sLabel = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor whiteColor];
            lb.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            lb.layer.cornerRadius = 3.f;
            lb.font = [UIFont systemFontOfSize:15];
            lb.layer.masksToBounds = YES;
            lb.text = @"请点击展品的文字标签或AR！";
            lb.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lb];
            lb;
        });
        _line = ({
            UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
            line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            [self addSubview:line];
            line;
        });
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.sLabel.mas_top);
        make.top.equalTo(self);
        make.width.equalTo(@2);
    }];
    [self.sLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@30);
    }];
}

- (void)startAnimation{
    CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
    shakeAnim.keyPath = @"transform.translation.x";
    shakeAnim.duration = 0.2;
    CGFloat delta = 15;
    shakeAnim.values = @[@0 , @(-delta), @(delta), @0];
    shakeAnim.repeatCount = 2;
    [self.sLabel.layer addAnimation:shakeAnim forKey:nil];
}


@end
