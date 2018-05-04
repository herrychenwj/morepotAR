//
//  RootLoadingView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/26.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "RootLoadingView.h"

@implementation RootLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HexRGBAlpha(0x000000, 0.4);
        self.layer.cornerRadius = 4.f;
        self.layer.masksToBounds = YES;
        _loadingCircle = ({
            LoadingCircle *circle = [[LoadingCircle alloc]initWithFrame:CGRectZero];
            circle.downloadProgress.progressColor = HexRGB(0xEC6728);
            circle.downloadProgress.progressBackgroundColor = [UIColor grayColor];
            [self addSubview:circle];
            circle;
        });
        _cancelBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            btn.backgroundColor = HexRGB(0xEC6728);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 4.f;
            btn.layer.masksToBounds = YES;
            [btn setTitle:@"取消更新" forState:UIControlStateNormal];
            [self addSubview:btn];
            btn;
        });
        _nameLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor whiteColor];
            lb.font = [UIFont systemFontOfSize:20];
            lb.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lb];
            lb;
        });
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(19);
        make.centerX.equalTo(self);
    }];
    [self.loadingCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.4);
        make.height.equalTo(self.loadingCircle.mas_width);
        make.top.equalTo(self.nameLB).offset(40);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.bottom.equalTo(self).offset(-25);
        make.height.equalTo(@35);
    }];
}


- (void)setPercent:(float)percent{
    _percent = percent;
    self.loadingCircle.progress = _percent;
    [self.cancelBtn setTitle:[NSString stringWithFormat:@"%@  %.f%%",[TXSakuraManager tx_stringWithPath:@"xlistview_header_hint_loading"],_percent*100] forState:UIControlStateNormal];
    [self.cancelBtn setTitle:[NSString stringWithFormat:@"%@  %.f%%",[TXSakuraManager tx_stringWithPath:@"xlistview_header_hint_loading"],_percent*100] forState:UIControlStateHighlighted];
}






@end
