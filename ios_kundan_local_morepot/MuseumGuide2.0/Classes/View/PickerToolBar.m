//
//  PickerToolBar.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "PickerToolBar.h"

@implementation PickerToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _cancelBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setTitle:[TXSakuraManager tx_stringWithPath:@"cancle"]  forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self addSubview:btn];
            btn;
        });
        _doneBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setTitle:[TXSakuraManager tx_stringWithPath:@"commit"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.titleLabel.textColor = [UIColor grayColor];
            [self addSubview:btn];
            btn;
        });
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.width.equalTo(@60);
    }];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-20);
        make.width.equalTo(@70);
    }];
}

@end
