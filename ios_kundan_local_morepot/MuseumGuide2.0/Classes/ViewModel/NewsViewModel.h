//
//  NewsViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewModel.h"

@interface NewsViewModel : BaseViewModel


/**
 当前新闻页
 */
@property (nonatomic,assign,readonly)NSInteger pageIndex;
/**
 新闻列表(重新获取)
 */
@property (nonatomic,strong,readonly)RACCommand *reloadNewsCmd;

/**
 获取更多新闻
 */
@property (nonatomic,strong,readonly)RACCommand *moreNewsCmd;
/**
 广告
 */
@property (nonatomic,strong,readonly)RACCommand *advertCmd;
/**
 新闻详情
 */
@property (nonatomic,strong)RACCommand *detailCmd;

@end
