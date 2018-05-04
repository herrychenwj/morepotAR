//
//  ExhibitToolBar.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ExhibitToolBar.h"

@implementation ExhibitToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _toolView = ({
            UIView *view= [[UIView alloc]initWithFrame:CGRectZero];
            view.backgroundColor = HexRGB(0xF7F9FC);
            [self addSubview:view];
            view;
        });
        
        _blankControl = ({
            UIControl *control = [[UIControl alloc]initWithFrame:CGRectZero];
            control.backgroundColor = [UIColor clearColor];
            [self addSubview:control];
            control;
        });
        
        _contentFD = ({
            UITextField *fd = [[UITextField alloc]initWithFrame:CGRectZero];
            fd.layer.cornerRadius = 4.f;
            fd.layer.masksToBounds = YES;
            fd.placeholder = [TXSakuraManager tx_stringWithPath:@"tellsome"];
            UIView *pV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
            fd.leftView = pV;
            fd.leftViewMode = UITextFieldViewModeAlways;
            fd.returnKeyType =  UIReturnKeySend;
            fd.layer.borderColor = HexRGB(0xD8D8D8).CGColor;
            fd.layer.borderWidth = 1.f;
            fd.font = [UIFont systemFontOfSize:15];
            [self.toolView addSubview:fd];
            fd;
        });
        _submitBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setTitle:[TXSakuraManager tx_stringWithPath:@"send"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
            [btn setTitleColor:HexRGB(0x287DF6) forState:UIControlStateNormal];
            [self.toolView addSubview:btn];
            btn;
        });
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@45);
    }];
    [self.blankControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.toolView.mas_top);
    }];
    [self.contentFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolView).offset(12);
        make.top.equalTo(self.toolView).offset(8);
        make.bottom.equalTo(self.toolView).offset(-8);
        make.right.equalTo(self.submitBtn.mas_left);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.toolView);
        make.width.equalTo(self.submitBtn.mas_height).multipliedBy(1);
    }];
}



@end
