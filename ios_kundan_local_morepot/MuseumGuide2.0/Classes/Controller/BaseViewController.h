//
//  BaseViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MuBackButton.h"
#import "BaseViewModel.h"


@interface BaseViewController : UIViewController

- (instancetype)initWithSkipType:(VCSkipType )skipType;


//跳转方式
@property (nonatomic,assign)VCSkipType skipType;


- (void)initUI;

- (void)bindViewModel;



//设置返回按钮标题
- (void)setBackTitle:(NSString *)title;

/**
 左上角返回按钮
 */
@property (nonatomic,strong)MuBackButton *backBtn;




@end



