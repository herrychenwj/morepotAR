//
//  UserSettingViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewModel.h"

@interface UserSettingViewModel : BaseViewModel
/**
 绑定手机号
 */
@property (nonatomic,strong)RACCommand *bindPhonenumCmd;
/**
 清除缓存
 */
@property (nonatomic,strong)RACCommand *cleanCacheCmd;



@property (nonatomic,strong)NSString *phoneNum;



@end
