//
//  MapExhibitCollectionViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/2.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MapExhibitCollectionViewCell.h"
@interface MapExhibitCollectionViewCell ()
@property (nonatomic,strong)UIView *line;
@end

@implementation MapExhibitCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _numLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.font = [UIFont systemFontOfSize:IPHONE_DEVICE?10:13 weight:UIFontWeightSemibold];
            lb.textColor = [UIColor whiteColor];
            lb.backgroundColor = HexRGB(0x715A39);
            [self addSubview:lb];
            lb;
        });
        _nameLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont italicSystemFontOfSize:IPHONE_DEVICE?12:14];
            lb.textColor = [UIColor whiteColor];
            lb.backgroundColor = HexRGB(0x202126);
            [self addSubview:lb];
            lb;
        });
        _exhibitImg = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            img.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:img];
            img;
        });
        _line = ({
            UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
            line.backgroundColor = [UIColor whiteColor];
            [self addSubview:line];
            line;
        });
    }
    return self;
}


- (void)setSelected:(BOOL)selected{
    self.numLB.backgroundColor = selected ? HexRGB(0xE38939):HexRGB(0x715A39);
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.numLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.height.equalTo(IPHONE_DEVICE?@32:@56);
    }];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLB.mas_right);
        make.right.equalTo(self.line.mas_left);
        make.top.bottom.equalTo(self.numLB);
    }];
    [self.exhibitImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.right.equalTo(self.line.mas_left);
        make.top.equalTo(self.numLB.mas_bottom);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(@1);
    }];
    
}

@end
