//
//  MuseumInfoHeaderView.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface MuseumInfoHeaderView : UIView
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *titleLB;
@property (nonatomic,strong)UIButton *playBtn;
@property (nonatomic,strong)UIButton *shareBtn;
@property (nonatomic,strong)SDCycleScrollView *bannerView;

@end
