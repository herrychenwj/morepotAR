//
//  MuseumInfoViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MuseumInfoModel.h"
#import "MuseumModel.h"

@interface MuseumInfoViewController : BaseViewController

- (instancetype)initWithBasicInfo:(MuseumModel *)basicInfo detailInfo:(MuseumInfoModel *)detailInfo;

@property (nonatomic,weak)MuseumModel *bascInfo;
@property (nonatomic,strong)MuseumInfoModel *detailInfo;

@end
