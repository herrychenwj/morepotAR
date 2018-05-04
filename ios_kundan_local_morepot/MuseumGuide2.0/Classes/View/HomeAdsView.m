//
//  HomeAdsView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/19.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "HomeAdsView.h"

@implementation HomeAdsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _adsImgView = ({
            UIImageView *imgView =[[UIImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:imgView];
            imgView;
        });
        _closeBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setTitle:@"close" forState:UIControlStateNormal];
            [self addSubview:btn];
            btn;
        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.adsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(20);
        make.width.height.equalTo(@44);
    }];
}



@end
