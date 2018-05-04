//
//  MapFloorTableViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/15.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MapFloorTableViewCell.h"

@implementation MapFloorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _floorLB = ({
            UILabel *lb= [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.layer.masksToBounds = YES;
            lb.layer.cornerRadius = IPHONE_DEVICE?14:22;
            [self.contentView addSubview:lb];
            lb;
        });
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    self.floorLB.backgroundColor = selected?[UIColor whiteColor]:HexRGB(0xE3E3E3);
    self.floorLB.textColor = selected?[UIColor blackColor]:HexRGB(0x6A6A6A);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.floorLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
        make.width.height.equalTo(IPHONE_DEVICE?@28:@44);
    }];
}




@end
