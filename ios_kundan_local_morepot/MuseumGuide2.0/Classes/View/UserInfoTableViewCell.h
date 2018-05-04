//
//  UserInfoTableViewCell.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,UserInfoCellType){
    UserInfoCellTypeImage,
    UserInfoCellTypeText
};
@interface UserInfoTableViewCell : UITableViewCell
@property (nonatomic,assign)UserInfoCellType cellType;
@property (nonatomic,strong)UILabel *titleLB;
@property (nonatomic,strong)UILabel *textLB;
@property (nonatomic,strong)UIImageView *avatarImg;


@end
