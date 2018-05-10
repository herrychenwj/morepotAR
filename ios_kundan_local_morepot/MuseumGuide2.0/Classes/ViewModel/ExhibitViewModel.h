//
//  ExhibitViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
#import "MuseumModel.h"

@interface ExhibitViewModel : BaseViewModel


/**
 重新获取评论
 */
@property (nonatomic,strong,readonly)RACCommand *reloadCmtCmd;

/**
 获取更多评论
 */
@property (nonatomic,strong,readonly)RACCommand *moreCmtCmd;

/**
 切换方言 (input传 音频的本地路径)
 */
@property (nonatomic,strong,readonly)RACCommand *playCmd;





/**
 评论内容
 */
@property (nonatomic,strong)NSString *comment;

/**
 展品ID
 */
@property (nonatomic,strong)NSString *exhibit_id;

/**
  是否可以收藏(已经登录)
 */
@property (nonatomic,assign)BOOL canCollect;

/**
 评论内容验证
 */
- (RACSignal *)cmtVerification;


/**
 是否登录
 */
@property (nonatomic,assign)BOOL isLogin;

/**
 是否可以收藏

 */
- (RACSignal *)allowCollection;


@property (nonatomic,weak)MuseumModel *basicInfo;



@end
