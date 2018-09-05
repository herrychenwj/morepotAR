//
//  RootTarBarController.h
//  PRO_TEST
//
//  Created by Mr.Huang on 2017/7/13.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyARViewController.h"
@interface RootTarBarController : UITabBarController

@property (nonatomic,strong)EasyARViewController *arVC;

- (void)configKuDan:(MuseumModel *)museum;

@end
