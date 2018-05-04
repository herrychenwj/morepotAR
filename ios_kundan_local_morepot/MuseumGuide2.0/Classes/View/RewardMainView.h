//
//  RewardMainView.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/22.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardMainView : UIView

@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *subLabel;
@property (nonatomic,strong)UILabel *chooseLabel;
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *midBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UIImageView *leftLine;
@property (nonatomic,strong)UIImageView *rightLine;
@property (nonatomic,strong)UILabel *rewardLabel;
@property (nonatomic,strong)UIButton *wxBtn;
@property (nonatomic,strong)UIButton *aliBtn;

@property (nonatomic,assign,readonly)NSInteger selectIndex;


@end
