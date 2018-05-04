//
//  SearchViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewModel.h"
#import "MuseumModel.h"

@interface SearchViewModel : BaseViewModel
/**
 搜索
 */
@property (nonatomic,strong,readonly)RACCommand *searchCmd;

/**
 地图搜索
 */
@property (nonatomic,strong,readonly)RACCommand *mapSeachCmd;

/**
 首页搜索
 */
@property (nonatomic,strong,readonly)RACCommand *homeSeachCmd;

/**
 根据展馆id列出所有展品
 */
@property (nonatomic,strong,readonly)RACCommand *allExhibitCmd;
/**
 搜索关键词
 */
@property (nonatomic,copy)NSString *keyword;


/**
 博物馆基本信息
 */
@property (nonatomic,weak)MuseumModel *basicInfo;


@end
