//
//  AdvertisementView.h
//  PRO_TEST
//
//  Created by Mr.Huang on 2017/7/13.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface AdvertisementView : UIView

@property (nonatomic,strong)SDCycleScrollView *bannerView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIPageControl *pageControl;


@end
