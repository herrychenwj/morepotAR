//
//  LanguageTableViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/10/25.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "LanguageTableViewCell.h"

@implementation LanguageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor whiteColor];
        _pointView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
            view.layer.cornerRadius = 7.f;
            view.layer.masksToBounds = YES;
            view.hidden = YES;
            view.backgroundColor = HexRGB(0xEC6728);
            [self addSubview:view];
            view;
        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@14);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
