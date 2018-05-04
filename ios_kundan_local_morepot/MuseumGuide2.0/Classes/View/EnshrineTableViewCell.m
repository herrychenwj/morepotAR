//
//  EnshrineTableViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "EnshrineTableViewCell.h"
@implementation EnshrineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _imgView = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imgView.layer.cornerRadius = 3.f;
            imgView.layer.masksToBounds = YES;
            [self.contentView addSubview:imgView];
            imgView;
        });
        _titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:17];
            lb.textColor = [UIColor whiteColor];
            [self.contentView addSubview:lb];
            lb;
        });
        _timeLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:14];
            lb.textColor = [UIColor lightGrayColor];
            lb.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:lb];
            lb;
        });
        _introduceLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:14];
            lb.textColor = [UIColor lightGrayColor];
            [self.contentView addSubview:lb];
            lb;
        });
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kBACK_SPACE);
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
        make.width.equalTo(self.imgView.mas_height).multipliedBy(1.4);
    }];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB);
        make.right.equalTo(self).offset(-20);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(8);
        make.top.equalTo(self.imgView.mas_top).offset(2);
        make.right.equalTo(self.timeLB.mas_left).offset(-8);
    }];

    [self.introduceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB);
        make.right.equalTo(self.timeLB);
        make.bottom.equalTo(self.imgView).offset(-2);
    }];
}



@end
