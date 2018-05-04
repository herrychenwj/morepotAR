//
//  ExhibitViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ExhibitInfoModel.h"
#import "MuseumModel.h"

@interface ExhibitViewController : BaseViewController

+ (ExhibitViewController *)exhibitControllerWithInfo:(ExhibitInfoModel *)exhibitInfo;

+ (ExhibitViewController *)exhibitControllerWithInfo:(ExhibitInfoModel *)exhibitInfo museumInfo:(MuseumModel *)museumInfo;

- (instancetype)initWithExhibitInfo:(ExhibitInfoModel *)exhibitInfo;

@property (nonatomic,weak)NSArray *goodsAry;

@property (nonatomic,weak)MuseumModel *museumInfo;

@property (nonatomic,strong)ExhibitInfoModel *exhibitInfo;

@property (nonatomic,copy)void(^refreshData)();


@end
