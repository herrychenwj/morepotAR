//
//  HomeFooterView.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/30.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MuItemButton.h"

@interface HomeFooterView : UIView
//- (instancetype)initWithFrame:(CGRect)frame andCardStyle:(BOOL)cardStyle;
@property (nonatomic,strong)MuItemButton *helpBtn;
@property (nonatomic,strong)MuItemButton *productBtn;
@property (nonatomic,strong)MuItemButton *strategyBtn;
@property (nonatomic,strong)MuItemButton *rootBtn;


/**
 是否是AR卡片模式
 */
@property (nonatomic,assign)BOOL arCardStyle;


@end

@interface FooterItemButton:MuItemButton



@end


