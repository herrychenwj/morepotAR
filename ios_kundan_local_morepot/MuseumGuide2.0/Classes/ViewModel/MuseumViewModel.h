//
//  MuseumViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/14.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewModel.h"
#import "MuseumInfoModel.h"
#import "MuseumModel.h"


@interface MuseumViewModel : BaseViewModel

/**
 音频播放预备
 */
@property (nonatomic,strong,readonly)RACCommand *audioReadyCmd;

@property (nonatomic,weak)MuseumInfoModel *detailInfo;

@property (nonatomic,weak)MuseumModel *basicInfo;



@end
