//
//  UserInfoViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewController.h"

@interface UserInfoViewController : BaseViewController

/**
 修改后回调
 */
@property (nonatomic,copy)void(^modification)();


@end
