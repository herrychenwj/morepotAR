//
//  StoreViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/11/8.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewModel.h"

@interface StoreViewModel : BaseViewModel
@property (nonatomic,strong,readonly)RACCommand *loadGoodsCmd;
@property (nonatomic,strong,readonly)RACCommand *museumListCmd;

@end
