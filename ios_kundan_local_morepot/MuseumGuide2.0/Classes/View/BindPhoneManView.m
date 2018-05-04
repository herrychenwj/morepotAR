//
//  BindPhoneManView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/6.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BindPhoneManView.h"

@interface BindPhoneManView ()
@property (nonatomic,strong)UIView *landscapeLine;
@property (nonatomic,strong)UIView *verticalLine;
@end


@implementation BindPhoneManView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.cornerRadius = 18;
        self.layer.masksToBounds = YES;
        self.bgView = ({
            UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
            [self addSubview:effectview];
            effectview;
        });
        self.landscapeLine = ({
            UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
            line.backgroundColor = HexRGB(0x646464);
            [self.bgView.contentView addSubview:line];
            line;
        });
        self.verticalLine = ({
            UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
            line.backgroundColor = HexRGB(0x646464);
            [self.bgView.contentView addSubview:line];
            line;
        });
        self.titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
            [self.bgView.contentView addSubview:lb];
            lb;
        });
        self.cancelBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            [btn setTitle:[TXSakuraManager tx_stringWithPath:@"cancle"] forState:UIControlStateNormal];
            [self.bgView.contentView addSubview:btn];
            btn;
        });
        self.doneBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            [btn setTitle:[TXSakuraManager tx_stringWithPath:@"commit"] forState:UIControlStateNormal];
            [self.bgView.contentView addSubview:btn];
            btn;
        });
        self.phoneFD = ({
            UITextField *fd = [[UITextField alloc]initWithFrame:CGRectZero];
            fd.keyboardType = UIKeyboardTypeNumberPad;
            fd.placeholder = [TXSakuraManager tx_stringWithPath:@"phonewrite"];
            fd.font = [UIFont systemFontOfSize:15];
            UIView *sp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 0)];
            fd.leftView  = sp;
            fd.leftViewMode = UITextFieldViewModeAlways;
            fd.layer.borderColor = HexRGB(0x646464).CGColor;
            fd.layer.borderWidth = 1.f;
            fd.backgroundColor = [UIColor whiteColor];
            [self.bgView.contentView addSubview:fd];
            fd;
        });
        self.codeFD = ({
            UITextField *fd = [[UITextField alloc]initWithFrame:CGRectZero];
            fd.placeholder = [TXSakuraManager tx_stringWithPath:@"pleasecode"];
            fd.keyboardType = UIKeyboardTypeNumberPad;
            fd.layer.borderColor = HexRGB(0x646464).CGColor;
            fd.font = [UIFont systemFontOfSize:15];
            UIView *sp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 0)];
            fd.leftView  = sp;
            fd.leftViewMode = UITextFieldViewModeAlways;
            fd.layer.borderWidth = 1.f;
            fd.backgroundColor = [UIColor whiteColor];
            [self.bgView.contentView addSubview:fd];
            fd;
        });
        self.sendBtn = ({
            AuthCodeButtom *btn = [AuthCodeButtom buttonWithType:UIButtonTypeSystem];
            [btn setTitle:[TXSakuraManager tx_stringWithPath:@"send_identifyin_code"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.bgView.contentView addSubview:btn];
            btn;
        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.contentView);
        make.top.equalTo(self.bgView.contentView).offset(20);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bgView.contentView);
        make.width.height.equalTo(self.doneBtn);
        make.right.equalTo(self.verticalLine.mas_left);
        make.height.equalTo(@42);
    }];
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self.bgView.contentView);
        make.width.equalTo(@1);
        make.height.equalTo(self.cancelBtn);
    }];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.bgView.contentView);
        make.left.equalTo(self.verticalLine.mas_right);
    }];
    [self.landscapeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.right.equalTo(self.bgView.contentView);
        make.bottom.equalTo(self.cancelBtn.mas_top);
    }];
    [self.phoneFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.contentView).offset(20);
        make.right.equalTo(self.bgView.contentView).offset(-20);
        make.height.equalTo(@25);
        make.top.equalTo(self.titleLB.mas_bottom).offset(20);
    }];
    [self.codeFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.phoneFD);
        make.top.equalTo(self.phoneFD.mas_bottom).offset(12);
        make.right.equalTo(self.sendBtn.mas_left).offset(-8);
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.equalTo(self.phoneFD);
        make.centerY.equalTo(self.codeFD);
        make.width.equalTo(@70);
    }];
    
    
    
}




@end
