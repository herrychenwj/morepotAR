//
//  RootSwitch.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/26.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "RootSwitch.h"

@implementation RootSwitch

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _bottonA = ({
            SwitchButton *btn = [[SwitchButton alloc]initWithFrame:CGRectZero];
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            btn.layer.borderWidth = 1.f;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius =  IPHONE_DEVICE?25.0:30;
            btn.textLabel.sakura.text(@"select_museum_textview");
            btn.tag = 1000;
            [btn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn;
        });
        _bottonB = ({
            SwitchButton *btn = [[SwitchButton alloc]initWithFrame:CGRectZero];
            btn.tag = 1001;
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius =  IPHONE_DEVICE?25.0:30;
            btn.textLabel.sakura.text(@"select_ar");
            btn.layer.borderWidth = 1.f;
            [btn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn;
        });
        _titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor whiteColor];
            lb.numberOfLines = 2;
            lb.textAlignment = NSTextAlignmentRight;
            lb.font = [UIFont systemFontOfSize:IPHONE_DEVICE?12:15];
            [self addSubview:lb];
            lb;
        });
        _subLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor whiteColor];
            lb.textAlignment = NSTextAlignmentRight;
            lb.numberOfLines = 2;
            lb.font = [UIFont systemFontOfSize:IPHONE_DEVICE?12:15];
            [self addSubview:lb];
            lb;
        });
        _selectedSegmentIndex = 0;
    }
    return self;
}


- (void)touchAction:(UIButton *)sender{
    [self selectAtIndex:sender.tag - 1000];
}

- (void)selectAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
            self.bottonA.selected = YES;
            self.bottonB.selected = NO;
            break;
        case 1:
            self.bottonA.selected = NO;
            self.bottonB.selected = YES;
            break;
        default:
            break;
    }
    self.selectedSegmentIndex = index;
}



- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bottonB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-26);
        make.top.bottom.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(self.bottonB.mas_height);
    }];
    [self.bottonA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(self.bottonB);
        make.right.equalTo(self.bottonB.mas_left).offset(-10);
    }];

    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self.bottonA.mas_left).offset(-8);
        make.centerY.equalTo(self);
    }];
    
    [self.subLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
        make.left.right.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(8);
    }];
}



@end

@implementation SwitchButton : UIButton


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _textLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.numberOfLines = 2;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:IPHONE_DEVICE?10:15];
            label;
        });
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setSelected:(BOOL)selected{
    self.backgroundColor = selected?[UIColor whiteColor]:[UIColor clearColor];
    self.textLabel.textColor = selected?[UIColor blackColor]:[UIColor whiteColor];
}



@end
