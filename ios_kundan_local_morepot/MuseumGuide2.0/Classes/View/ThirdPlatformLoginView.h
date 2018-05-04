//
//  ThirdPlatformLoginView.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MuItemButton;
@interface ThirdPlatformLoginView : UIView
@property (nonatomic,strong)MuItemButton *QQLoginBtn;
@property (nonatomic,strong)MuItemButton *WeChatBtn;
@property (nonatomic,strong)MuItemButton *SinaBtn;
@property (nonatomic,strong)UILabel *titleLB;
@end
