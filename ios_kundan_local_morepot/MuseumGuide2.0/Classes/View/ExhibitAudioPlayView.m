//
//  ExhibitAudioPlayView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ExhibitAudioPlayView.h"

@implementation ExhibitAudioPlayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _playBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
            [self addSubview:btn];
            btn;
        });
        
        _slider = ({
            UISlider *progress = [[UISlider alloc]initWithFrame:CGRectZero];
            [progress setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
            [progress setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateHighlighted];
           progress.minimumTrackTintColor = [UIColor whiteColor];
            [self addSubview:progress];
            progress;
        });
        _languageBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            btn.layer.cornerRadius = 3.f;
            btn.layer.borderWidth = 1.f;
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            btn.layer.masksToBounds = YES;
            [btn setTitle:[TXSakuraManager tx_stringWithPath:@"local_sounds"] forState:UIControlStateNormal];
            [btn setTitle:[TXSakuraManager tx_stringWithPath:@"mandarin"] forState:UIControlStateSelected];
            btn.hidden = YES;
            [self addSubview:btn];
            btn;
        });
        _timeLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:10];
            lb.textColor = [UIColor whiteColor];
            lb.text = @"0:00";
            [self addSubview:lb];
            lb;
        });
        _allTimeLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:10];
            lb.textColor = [UIColor whiteColor];
            lb.textAlignment = NSTextAlignmentRight;
            lb.text = @"0:00";
            [self addSubview:lb];
            lb;
        });
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self.playBtn.mas_height).multipliedBy(1);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).offset(8);
        make.top.equalTo(self.languageBtn).offset(4);
        make.right.equalTo(self.languageBtn.mas_left).offset(self.languageBtn.hidden?50:-16);
        make.height.equalTo(@2);
    }];
    [self.languageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.equalTo(@50);
        make.centerY.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(0.6);
    }];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider);
        make.top.equalTo(self.slider.mas_bottom).offset(4);
    }];
    [self.allTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.slider);
        make.top.equalTo(self.timeLB);
    }];
    
}


- (void)setDialectShow:(BOOL)dialectShow{
    _dialectShow = dialectShow;
    if (_dialectShow) {
        self.languageBtn.hidden = NO;
        [self layoutIfNeeded];
    }
}


- (void)setEnabled:(BOOL)enabled{
    _enabled = enabled;
    self.allTimeLB.enabled = self.timeLB.enabled = self.languageBtn.enabled = self.slider.enabled = self.playBtn.enabled = _enabled;
}

- (void)layoutIfNeeded{
    [super layoutIfNeeded];
    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).offset(8);
        make.top.equalTo(self.languageBtn).offset(4);
        make.right.equalTo(self.languageBtn.mas_left).offset(self.languageBtn.hidden?40:-12);
        make.height.equalTo(@2);
    }];
}

@end
