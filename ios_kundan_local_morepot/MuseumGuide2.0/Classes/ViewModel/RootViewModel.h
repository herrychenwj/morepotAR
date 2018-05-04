//
//  RootViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

@interface RootViewModel : BaseViewModel


/**
 加载博物馆列表
 */
@property (nonatomic,strong,readonly)RACCommand *museumListCmd;

/**
 下载AR资源包
 */
@property (nonatomic,strong,readonly)RACCommand *loadARCmd;


/**
 下载进度
 */
@property (nonatomic,assign)float downloadProgress;
/**
 是否显示进度条
 */
@property (nonatomic,assign)BOOL showProgress;



@property (nonatomic,strong)NSDictionary *gpsInfo;


@end
