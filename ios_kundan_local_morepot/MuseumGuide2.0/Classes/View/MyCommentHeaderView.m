//
//  MyCommentHeaderView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MyCommentHeaderView.h"

@interface MyCommentHeaderView ()
@property (nonatomic,strong)UIImageView *arrow;
@property (nonatomic,strong)UIView *bottomLine;

@end
@implementation MyCommentHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _exhibitImg = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            img.layer.cornerRadius = 4.f;
            img.layer.masksToBounds = YES;
            [self addSubview:img];
            img;
        });
        _exhibitNameLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:18];
            lb.textColor = [UIColor whiteColor];
            [self addSubview:lb];
            lb;
        });
        _timeLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:12];
            lb.textColor = [UIColor lightGrayColor];
            [self addSubview:lb];
            lb;
        });
        _arrow = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            img.image = [UIImage imageNamed:@"list_right"];
            [self addSubview:img];
            img;
        });
        _bottomLine = ({
            UIView *view =[[UIView alloc]initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:view];
            view;
        });
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.exhibitImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(20);
        make.bottom.equalTo(self).offset(-20);
        make.width.equalTo(self.exhibitImg.mas_height).multipliedBy(1.4);
    }];
    [self.exhibitNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.exhibitImg.mas_right).offset(12);
        make.bottom.equalTo(self.mas_centerY).offset(-2);
        make.right.equalTo(self.arrow).offset(-8);
    }];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.exhibitNameLB);
        make.top.equalTo(self.mas_centerY).offset(2);
    }];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.equalTo(@12);
        make.height.equalTo(self.arrow.mas_width).multipliedBy(48.0/25.0);
        make.centerY.equalTo(self);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}


@end
