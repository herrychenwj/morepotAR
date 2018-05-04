//
//  EnshrineViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,ListControllerType){
    ListControllerType_Collection, //收藏
    ListControllerType_Comment ,//评论
    ListControllerType_Footprint,//浏览
};

@interface EnshrineViewController : BaseViewController


+ (EnshrineViewController *)Controller:(ListControllerType)type;


@end
