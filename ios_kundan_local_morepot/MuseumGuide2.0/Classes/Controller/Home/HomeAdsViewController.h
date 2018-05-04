//
//  HomeAdsViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/19.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeAdsViewController : BaseViewController

- (instancetype)initWithAdsImgUrl:(NSString *)adsimgUrl;
@property (nonatomic,copy)NSString *adsURL;



@end
