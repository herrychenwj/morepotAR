//
//  DiscoverItemCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/10/11.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "DiscoverItemCell.h"

@implementation DiscoverItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imgView;
        });
        _contentLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.numberOfLines = 2;
            label.font = [UIFont systemFontOfSize:14];
            label;
        });
        [self addSubview:_imageView];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
//        make.height.equalTo(self.imageView.mas_width);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.equalTo(@40);
        make.top.equalTo(self.imageView.mas_bottom).offset(8);
        make.bottom.equalTo(self).offset(-8);
    }];
    
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
}

@end
