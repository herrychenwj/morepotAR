//
//  ARHomeViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/23.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewModel.h"
#import "MuseumModel.h"



@interface ARHomeViewModel : BaseViewModel


@property (nonatomic,strong,readonly)RACCommand *loadGoodsCmd;


/**
 加载博物馆信息
 */
@property (nonatomic,strong,readonly)RACCommand *loadInfoCmd;
/**
 加载iBeacon
 */
@property (nonatomic,strong,readonly)RACCommand *iBeaconCmd;

@property (nonatomic,weak)MuseumModel *basicInfo;



@end
