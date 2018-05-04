//
//  AuthCodeButtom.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/16.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthCodeButtom : UIButton
- (void)startUpTimer;
- (void)invalidateTimer;
//是否在倒计时
@property (nonatomic,assign)BOOL isRunning;



@end
