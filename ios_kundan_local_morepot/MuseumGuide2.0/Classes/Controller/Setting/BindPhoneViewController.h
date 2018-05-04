//
//  BindPhoneViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/6.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BindPhoneViewController : BaseViewController



+ (BindPhoneViewController *)VerificationNextAction:(void(^)(NSString *))nextBlock type:(NSNumber *)type;

@end
