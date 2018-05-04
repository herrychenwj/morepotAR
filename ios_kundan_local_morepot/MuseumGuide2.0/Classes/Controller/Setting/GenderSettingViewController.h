//
//  GenderSettingViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface GenderSettingViewController : BaseViewController

/**
 @param doneAction 0表示男，1表示女
 */
+ (GenderSettingViewController *)genderControllerDoneAction:(void(^)(NSString*))doneAction;
@end
