//
//  PayMainView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/6/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "PayMainView.h"

@implementation PayMainView
- (instancetype)initWithFrame:(CGRect)frame reviewsMode:(BOOL)reviewsMode{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        self.reviewsMode = reviewsMode;
        _payView = ({
            ThirdPayView *view = [[ThirdPayView alloc]initWithFrame:CGRectZero reviewsMode:self.reviewsMode];
            [self addSubview:view];
            view;
        });
        _imgView = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image = [UIImage imageNamed:@"content"];
            [self addSubview:imgView];
            imgView;
        });

        _closeBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setImage:[UIImage imageNamed:@"pay_cancel"] forState:UIControlStateNormal];
            [self addSubview:btn];
            btn;
        });
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@101);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.closeBtn.mas_bottom).offset(4);
        make.bottom.equalTo(self.payView.mas_top).offset(-12);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(self).offset(12);
        make.width.height.equalTo(@35);
    }];
    
}




@end

@interface ThirdPayView ()
@property (nonatomic,strong)UIImageView *leftline;
@property (nonatomic,strong)UIImageView *rightline;
@property (nonatomic,strong)UILabel *titleLabel;
@end
@implementation ThirdPayView

- (instancetype)initWithFrame:(CGRect)frame reviewsMode:(BOOL)reviewsMode{
    if (self = [super initWithFrame:frame]) {
        _appleBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setImage:[UIImage imageNamed:@"pay_apple"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"pay_apple"] forState:UIControlStateHighlighted];
            [self addSubview:btn];
            btn;
        });
    _leftline = ({
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = [UIImage imageNamed:@"pay_left"];
        [self addSubview:imgView];
        imgView;
    });
    _rightline = ({
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = [UIImage imageNamed:@"pay_right"];
        [self addSubview:imgView];
        imgView;
    });
    _titleLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = @"点击购买";
        label.textColor = HexRGB(0x525252);
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label;
    });
    }
    return self;
}



- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self).offset(12);
        make.height.equalTo(@1);
    }];
    [self.rightline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right);
        make.top.height.equalTo(self.leftline);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@105);
        make.centerY.equalTo(self.leftline);
    }];
    
    [self.appleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.centerY.equalTo(self);
        make.centerX.equalTo(self);
        make.height.width.equalTo(self.mas_height).multipliedBy(0.6);
    }];

}



@end
