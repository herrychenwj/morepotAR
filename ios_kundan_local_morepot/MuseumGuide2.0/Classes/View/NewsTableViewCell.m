//
//  NewsTableViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.cornerRadius = 8.f;
        self.backgroundColor = HexRGBAlpha(0x000000, 0.45);
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        _imgView = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            img.layer.borderColor = [UIColor whiteColor].CGColor;
            img.layer.borderWidth = 1.f;
            img.layer.masksToBounds = YES;
            [self.contentView addSubview:img];
            img;
        });

        _titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor whiteColor];
            lb.numberOfLines = 2;
            lb.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:lb];
            lb;
        });
        _timeLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor lightGrayColor];
            lb.font = [UIFont systemFontOfSize:13];
            lb.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:lb];
            lb;
        });
//        _subTitleLB = ({
//            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
//            lb.textColor = [UIColor whiteColor];
//            lb.font = [UIFont systemFontOfSize:18];
//            [self.contentView addSubview:lb];
//            lb;
//        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
        make.width.equalTo(self.imgView.mas_height).multipliedBy(1);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(12);
        make.top.equalTo(self.imgView).offset(2);
        make.right.equalTo(self).offset(-16);
    }];
//    [self.subTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.titleLB);
//        make.top.equalTo(self.titleLB.mas_bottom).offset(2);
//    }];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.titleLB);
        make.bottom.equalTo(self).offset(-2);
        make.top.equalTo(self.titleLB.mas_bottom).offset(2);
    }];
    
}


- (void)setFrame:(CGRect)frame{
    CGRect f = frame;
    CGRect newF = CGRectMake(f.origin.x+22, f.origin.y+4,f.size.width-2*22, f.size.height - 2*4);
    self.imgView.layer.cornerRadius = (frame.size.height - 2*8-2*4)/2;
    [super setFrame:newF];
    
}

@end
