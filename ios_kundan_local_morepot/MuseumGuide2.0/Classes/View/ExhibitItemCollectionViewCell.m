//
//  ExhibitItemCollectionViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ExhibitItemCollectionViewCell.h"

@implementation ExhibitItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        _exhibitImg = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            img.backgroundColor = [UIColor purpleColor];
            [self addSubview:img];
            img;
        });
        _exhibitNameLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:12];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.textColor = [UIColor whiteColor];
            lb.backgroundColor = [UIColor redColor];
            [self addSubview:lb];
            lb;
        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.exhibitImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.75);
    }];
    [self.exhibitNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.exhibitImg.mas_bottom);
    }];
    
}


@end
