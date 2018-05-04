//
//  FeedbackViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/30.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewModel.h"

@interface FeedbackViewModel : BaseViewModel
@property (nonatomic,strong,readonly)RACCommand *submitCmd;

@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *contact;


@end
