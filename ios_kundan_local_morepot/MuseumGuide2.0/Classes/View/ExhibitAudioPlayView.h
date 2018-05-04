//
//  ExhibitAudioPlayView.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExhibitAudioPlayView.h"

@interface ExhibitAudioPlayView : UIView
@property (nonatomic,strong)UIButton *playBtn;
@property (nonatomic,strong)UISlider *slider;
@property (nonatomic,strong)UIButton *languageBtn;
@property (nonatomic,strong)UILabel *timeLB;
@property (nonatomic,strong)UILabel *allTimeLB;
@property (nonatomic,assign)BOOL dialectShow;

@property (nonatomic,assign)BOOL enabled;



@end
