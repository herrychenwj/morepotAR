//
//  LoginViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewController.h"
#import "MuseumModel.h"

@interface LoginViewController : BaseViewController


+ (LoginViewController *)loginControllerWithLoginSuccess:(void(^)())loginSuccess;

@property (nonatomic,weak)MuseumModel *museum;



@end
