//
//  ShareViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "MuseumModel.h"

@interface ShareViewController : BaseViewController

@property (nonatomic,weak)MuseumModel *museum;

+ (ShareViewController *)shareWithObject:(UMShareWebpageObject *)shareObj;
@property (nonatomic,strong)UMShareWebpageObject *shareObject;

/**
   追踪分享项目类型：展品，展馆
 */
@property (nonatomic,copy)NSString  *shareObjType;
/**
 追踪分享分享Label
 */
@property (nonatomic,copy)NSString  *trackLabel;


@end


