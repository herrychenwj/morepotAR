//
//  ShareCollectionViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ShareCollectionViewCell.h"

@implementation ShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _itemImg = ({
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:imgV];
            imgV;
        });
        _itemTitleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:14];
            lb.textColor = [UIColor whiteColor];
            lb.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:lb];
            lb;
        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.height.equalTo(self.itemImg.mas_width);
    }];
    [self.itemTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.itemImg.mas_bottom).offset(8);
    }];
}


@end
