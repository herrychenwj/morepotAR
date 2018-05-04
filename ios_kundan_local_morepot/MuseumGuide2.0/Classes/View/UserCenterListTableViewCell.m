//
//  UserCenterListTableViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/7/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UserCenterListTableViewCell.h"
#import <Masonry/Masonry.h>


@interface UserCenterListTableViewCell()
@property (nonatomic,strong)UIView *line;
@end

@implementation UserCenterListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _iconView = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:img];
            img;
        });
        _titleLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:18];
            [self addSubview:label];
            label;
        });
        _numLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
        });
        _arrowImgView = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            img.image = [UIImage imageNamed:@"list_right"];
            [self addSubview:img];
            img;
        });
        _line = ({
            UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
            line.backgroundColor = HexRGB(0x585858);
            [self line];
            [self addSubview:line];
            line;
        });
        
        _switchX = ({
            UISwitch *switchx = [[UISwitch alloc]initWithFrame:CGRectZero];
            switchx.onTintColor = HexRGB(0xEC6728);
            switchx.transform = CGAffineTransformMakeScale(0.6, 0.6);
            switchx.tintColor = [UIColor lightGrayColor];
            [self addSubview:switchx];
            switchx;
        });
        
        
    }
    return self;
}

- (void)setCellType:(ListCellType)cellType{
    _cellType = cellType;
    switch (_cellType) {
        case ListCellTypeNone:{
            self.numLabel.hidden = self.arrowImgView.hidden = self.switchX.hidden = YES;
        }break;
        case ListCellTypeLabel:{
            self.arrowImgView.hidden = self.numLabel.hidden = NO;
            self.switchX.hidden = YES;
        }break;
        case ListCellTypeSwitch:{
            self.switchX.hidden = NO;
            self.numLabel.hidden = self.arrowImgView.hidden =  YES;
        }break;
        case ListCellTypeArrow:{
            self.arrowImgView.hidden = NO;
            self.numLabel.hidden = self.switchX.hidden = YES;
        }break;
        default:
            break;
    }
}




- (void)layoutSubviews{
    [super layoutSubviews];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(49);
        make.width.height.equalTo(@30);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.iconView.mas_right).offset(11);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImgView.mas_left).offset(-6);
        make.centerY.equalTo(self);
    }];
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-28);
        make.centerY.equalTo(self);
        make.width.equalTo(@10);
        make.height.equalTo(@21);
    }];
    [self.switchX mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.numLabel).offset(4);
        make.centerY.equalTo(self);
        make.centerX.equalTo(self.arrowImgView);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(38);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];

    
}



@end
