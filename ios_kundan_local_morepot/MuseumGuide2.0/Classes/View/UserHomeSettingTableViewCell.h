//
//  UserInfoSettingTableViewCell.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,UserInfoCellType){
    UserInfoCellTypeNone,
    UserInfoCellTypeArrow,
    UserInfoCellTypePoint
};



@interface UserHomeSettingTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLB;
@property (nonatomic,strong)UIButton *tagBtn;
@property (nonatomic,assign)UserInfoCellType cellType;
@property (nonatomic,strong)UILabel *subLB;


@end
