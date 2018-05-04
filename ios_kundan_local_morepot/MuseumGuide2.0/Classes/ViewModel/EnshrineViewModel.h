//
//  EnshrineViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/30.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewModel.h"

@interface EnshrineViewModel : BaseViewModel

/**
 收藏列表 (input传登录状态)
 */
@property (nonatomic,strong,readonly)RACCommand *favCmd;



@property (nonatomic,strong,readonly)RACCommand *cmtlistCmd;


@property(nonatomic,strong,readonly)RACCommand *footprintCmd;


@end
