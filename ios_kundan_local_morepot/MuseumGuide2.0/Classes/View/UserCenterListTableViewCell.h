//
//  UserCenterListTableViewCell.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/7/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ListCellType){
    ListCellTypeNone,
    ListCellTypeLabel,
    ListCellTypeSwitch,
    ListCellTypeArrow
};

@interface UserCenterListTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *arrowImgView;
@property (nonatomic,strong)UILabel *numLabel;
@property (nonatomic,strong)UISwitch *switchX;

@property (nonatomic,assign)ListCellType cellType;



@end
