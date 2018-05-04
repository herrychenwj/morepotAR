//
//  ExhibitThumbImageCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/6/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ExhibitThumbImageCell.h"

@implementation ExhibitThumbImageCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.thumbImgView = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:imgView];
            imgView;
        });
        self.playIcon = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imgView.image = [UIImage imageNamed:@"movie"];
            imgView.hidden = YES;
            [self addSubview:imgView];
            imgView;
        });
    }
    return self;
}


- (void)setMovieMode:(BOOL)movie{
    self.playIcon.hidden = !movie;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.thumbImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@30);
    }];
}


@end
