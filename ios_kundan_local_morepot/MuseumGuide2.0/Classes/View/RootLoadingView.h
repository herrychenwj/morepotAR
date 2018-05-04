//
//  RootLoadingView.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/26.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadProgress.h"

@interface RootLoadingView : UIView
/**
 进度条
 */
@property (nonatomic,strong)LoadingCircle *loadingCircle;

/**
 进入label
 */
@property (nonatomic,strong)UIButton *cancelBtn;

/**
 博物馆名字
 */
@property (nonatomic,strong)UILabel *nameLB;

@property (nonatomic,assign)float percent;



@end
