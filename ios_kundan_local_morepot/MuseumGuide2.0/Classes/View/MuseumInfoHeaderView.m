//
//  MuseumInfoHeaderView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MuseumInfoHeaderView.h"

@implementation MuseumInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        _bgView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            view.layer.cornerRadius = 8.f;
            [self addSubview:view];
            view;
        });
        
        _titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor whiteColor];
            lb.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
            [self addSubview:lb];
            lb;
        });
        _bannerView = ({
            SDCycleScrollView *banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder"]];
            banner.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            banner.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
            banner.autoScrollTimeInterval = 4.f;
            [self addSubview:banner];
            banner;
        });
        _playBtn= ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setImage:[UIImage imageNamed:@"sound"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"play2"] forState:UIControlStateSelected];
            btn.userInteractionEnabled = NO;
            btn.enabled = NO;
            [self addSubview:btn];
            btn;
        });
        _shareBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateHighlighted];
            btn.userInteractionEnabled = NO;
            btn.enabled = NO;
            [self addSubview:btn];
            btn;
        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 20));
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(12);
        make.height.equalTo(@30);
    }];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(8);
        make.bottom.equalTo(self).offset(-20);
        make.right.equalTo(self.playBtn.mas_left).offset(-8);
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bannerView.mas_centerY).offset(-30);
        make.width.height.equalTo(IPHONE_DEVICE?@44:@55);
        make.centerX.equalTo(self.bgView.mas_right).offset(-4);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bannerView.mas_centerY).offset(30);
        make.width.centerX.height.equalTo(self.playBtn);
    }];
}



@end
