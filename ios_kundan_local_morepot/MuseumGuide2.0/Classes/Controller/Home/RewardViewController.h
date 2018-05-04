//
//  RewardViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MuseumModel.h"

@interface RewardViewController : BaseViewController

@property (nonatomic,copy)void(^rewardSuccess)();

@property (nonatomic,copy)NSString *trackName;

@end
