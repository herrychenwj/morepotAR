//
//  BindPhoneManView.h
//  sss
//
//  Created by Mr.Huang on 2017/4/6.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthCodeButtom.h"

@interface BindPhoneManView : UIView
@property (nonatomic,strong)UIVisualEffectView *bgView;

@property (nonatomic,strong)UILabel *titleLB;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *doneBtn;
@property (nonatomic,strong)UITextField *phoneFD;
@property (nonatomic,strong)UITextField *codeFD;
@property (nonatomic,strong)AuthCodeButtom *sendBtn;


@end
