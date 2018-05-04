//
//  ExhibitFooterView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ExhibitFooterView.h"

@implementation ExhibitFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.layer.cornerRadius = 6.f;
        self.layer.masksToBounds = YES;
        _commentBtn = ({
            CommentButton *btn = [[CommentButton alloc]initWithFrame:CGRectZero];
            btn.placeLB.sakura.text(@"tellsome");
            [self addSubview:btn];
            btn;
        });
        _likeBtn = ({
            LikeButton *btn = [[LikeButton alloc]initWithFrame:CGRectZero];
            [self addSubview:btn];
            btn;
        });
        _topBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"top"] forState:UIControlStateHighlighted];
            [self addSubview:btn];
            btn;
        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
        make.right.equalTo(self.likeBtn.mas_left).offset(-8);
    }];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentBtn);
        make.right.equalTo(self).offset(-8);
        make.height.equalTo(@20);
        make.width.equalTo(self.topBtn.mas_height);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentBtn);
        make.right.equalTo(self.topBtn.mas_left).offset(-8);
        make.height.equalTo(self.topBtn);
        make.width.equalTo(@48);
    }];
    
}

@end

@implementation CommentButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 3.f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.f;
        _placeLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor =[UIColor whiteColor];
            lb.font = [UIFont systemFontOfSize:13];
            [self addSubview:lb];
            lb;
        });
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.placeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(2, 4, 2, 2));
    }];
}

@end



@implementation LikeButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imgView = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            img.image = [UIImage imageNamed:@"zan"];
            [self addSubview:img];
            img;
        });
        _countLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor whiteColor];
            lb.textAlignment = NSTextAlignmentRight;
            lb.font = [UIFont systemFontOfSize:15];
            [self addSubview:lb];
            lb;
        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.height.equalTo(@16);
        make.centerY.equalTo(self);
    }];
    [self.countLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imgView.mas_left).offset(-2);
        make.left.equalTo(self).offset(2);
        make.centerY.equalTo(self).offset(2);
    }];
}

- (void)setStatus:(BOOL)status{
    _status = status;
    if (_status) { //从无到有
        self.userInteractionEnabled = NO;
        self.imgView.image = [UIImage imageNamed:@"comment_point_praise_ed"];
    }
}

//- (void)setEnabled:(BOOL)enabled{
//    [super setEnabled:enabled];
//    if (!enabled) {
//        self.userInteractionEnabled = NO;
//        self.imgView.image = [UIImage imageNamed:@"comment_point_praise_ed"];
//    }
//}

@end
