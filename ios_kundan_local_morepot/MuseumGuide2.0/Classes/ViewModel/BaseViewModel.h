//
//  BaseViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseViewModel : NSObject


- (instancetype)initWithHUDShowView:(UIView *)view;

@property (nonatomic,weak)UIView *hudView;

@property (nonatomic,strong,readonly)RACCommand *exhibitInfoCmd;


@end
