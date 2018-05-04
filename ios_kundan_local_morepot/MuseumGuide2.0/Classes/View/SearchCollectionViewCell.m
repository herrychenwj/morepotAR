//
//  SearchCollectionViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/6/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@implementation SearchCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imgView = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:imgView];
            imgView;
        });
        _nameLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor whiteColor];
            lb.font = [UIFont systemFontOfSize:14];
            lb.backgroundColor = HexRGB(0x755933);
            lb.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lb];
            lb;
        });
//        _lockView = ({
//            UIView *lockView = [[UIView alloc]initWithFrame:CGRectZero];
//            lockView.backgroundColor = HexRGBAlpha(0x000000, 0.4);
//            [self addSubview:lockView];
//            lockView;
//        });
//
//        _lockImgView = ({
//            UIImageView *imgView =[[ UIImageView alloc]initWithFrame:CGRectZero];
//            imgView.image = [UIImage imageNamed:@"pay_lock"];
//            [self addSubview:imgView];
//            imgView;
//        });
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.f;
        self.layer.masksToBounds = YES;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.bottom.equalTo(self.nameLB.mas_top);
        make.height.equalTo(self.imgView.mas_width).multipliedBy(0.75);//图片比例4:3
    }];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
//    [self.lockImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.imgView);
//        make.width.height.equalTo(self.imgView.mas_width).multipliedBy(0.4);
//    }];
//    [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
}



@end
