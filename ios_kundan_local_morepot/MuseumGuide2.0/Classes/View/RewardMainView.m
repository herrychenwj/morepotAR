//
//  RewardMainView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/22.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "RewardMainView.h"

@interface RewardMainView()
@property (nonatomic,assign,readwrite)NSInteger selectIndex;
@end

@implementation RewardMainView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:21 weight:1.5];
            label.textColor = HexRGB(0xE7501F);
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
        });
        _subLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = HexRGB(0x3C3C3C);
            label.numberOfLines = 2;
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
        });
        _chooseLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = HexRGB(0xE7501F);
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
        });
        _midBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:HexRGB(0xE7501F) forState:UIControlStateSelected];
            btn.layer.cornerRadius = 3.f;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.layer.borderColor = HexRGB(0xC2C2C2).CGColor;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1.f;
            btn.tag = 101;
            [btn addTarget:self action:@selector(rewardClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn;
        });
        _leftBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:HexRGB(0xE7501F) forState:UIControlStateSelected];
            btn.layer.cornerRadius = 3.f;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.layer.borderColor = HexRGB(0xC2C2C2).CGColor;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1.f;
            btn.tag = 100;
            [btn addTarget:self action:@selector(rewardClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn;
        });
        _rightBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:HexRGB(0xE7501F) forState:UIControlStateSelected];
            btn.tag = 102;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn addTarget:self action:@selector(rewardClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.cornerRadius = 3.f;
            btn.layer.borderColor = HexRGB(0xC2C2C2).CGColor;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1.f;
            [self addSubview:btn];
            btn;
        });
        _closeBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setImage:[UIImage imageNamed:@"pay_cancel"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"pay_cancel"] forState:UIControlStateHighlighted];
            [self addSubview:btn];
            btn;
        });
        _leftLine = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imgView.image = [UIImage imageNamed:@"pay_left"];
            [self addSubview:imgView];
            imgView;
        });
        _rightLine = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imgView.image = [UIImage imageNamed:@"pay_right"];
            [self addSubview:imgView];
            imgView;
        });
        _rewardLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = HexRGB(0x5A5A5A);
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
        });
        _wxBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setBackgroundImage:[UIImage imageNamed:@"pay_wx"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"pay_wx"] forState:UIControlStateHighlighted];
            [self addSubview:btn];
            btn;
        });
        _aliBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setBackgroundImage:[UIImage imageNamed:@"pay_ali"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"pay_ali"] forState:UIControlStateHighlighted];
            [self addSubview:btn];
            btn;
        });
        self.selectIndex = 0;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.top.equalTo(self).offset(4);
        make.width.height.equalTo(@44);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.right.equalTo(self);
        make.top.equalTo(self.closeBtn.mas_bottom);
    }];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
    }];
    [self.chooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.right.equalTo(self);
        make.top.equalTo(self.subLabel.mas_bottom).offset(32);
    }];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-80);
        make.top.equalTo(self.chooseLabel.mas_bottom).offset(24);
        make.height.equalTo(@28);
        make.width.equalTo(self.leftBtn.mas_height).multipliedBy(154.0/68.0);
    }];
    [self.midBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.width.height.equalTo(self.leftBtn);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(80);
        make.top.width.height.equalTo(self.leftBtn);
    }];
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.rightBtn.mas_bottom).offset(26);
        make.width.equalTo(@104);
    }];
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.rewardLabel.mas_left).offset(-2);
        make.centerY.equalTo(self.rewardLabel);
        make.height.equalTo(@1.5);
    }];
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self.rewardLabel.mas_right).offset(2);
        make.centerY.equalTo(self.rewardLabel);
        make.height.equalTo(@1.5);
    }];

    [self.wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rewardLabel.mas_bottom).offset(24);
        make.width.height.equalTo(@48);
        make.right.equalTo(self.leftBtn.mas_right).offset(-2);
    }];
    [self.aliBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(self.wxBtn);
        make.left.equalTo(self.rightBtn.mas_left).offset(2);
    }];
}


- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    switch (_selectIndex) {
            case 0:{
                self.leftBtn.layer.borderColor = HexRGB(0xE7501F).CGColor;
                self.midBtn.layer.borderColor = self.rightBtn.layer.borderColor = HexRGB(0xC2C2C2).CGColor;
                self.leftBtn.selected = YES;
                self.rightBtn.selected = self.midBtn.selected = NO;
            }
            break;
            case 1:{
                self.midBtn.layer.borderColor = HexRGB(0xE7501F).CGColor;
                self.leftBtn.layer.borderColor = self.rightBtn.layer.borderColor = HexRGB(0xC2C2C2).CGColor;
                self.midBtn.selected = YES;
                self.rightBtn.selected = self.leftBtn.selected = NO;
            }
            break;
            case 2:{
                self.rightBtn.layer.borderColor = HexRGB(0xE7501F).CGColor;
                self.leftBtn.layer.borderColor = self.midBtn.layer.borderColor = HexRGB(0xC2C2C2).CGColor;
                self.rightBtn.selected = YES;
                self.midBtn.selected = self.leftBtn.selected = NO;
            }
            break;
        default:
            break;
    }
//    self.leftBtn.layer.borderColor = (_selectIndex == 0)?HexRGB(0xE7501F).CGColor:HexRGB(0xC2C2C2).CGColor;
//    self.rightBtn.layer.borderColor = (_selectIndex == 0)?HexRGB(0xC2C2C2).CGColor:HexRGB(0xE7501F).CGColor;
//    self.leftBtn.selected = (_selectIndex == 0);
//    self.rightBtn.selected = !(_selectIndex == 0);
}

- (void)rewardClick:(UIButton *)sender{
    self.selectIndex = sender.tag - 100;
}

@end
