//
//  MapGuideViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/15.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
#import "MuseumModel.h"

@interface MapGuideViewModel : BaseViewModel
/**
 博物馆地图信息加载
 */
@property (nonatomic,strong,readonly)RACCommand *mapInfoCmd;

/**
 头部展品加载
 */
@property (nonatomic,strong,readonly)RACCommand *topExhibitionCmd;

@property (nonatomic,weak)MuseumModel *basicInfo;


@end
