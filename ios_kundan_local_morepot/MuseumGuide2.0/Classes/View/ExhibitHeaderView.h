//
//  ExhibitHeaderView.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExhibitAudioPlayView.h"
#import "ExhibitThumbImageCell.h"
#import "ExhibitThumbModel.h"


@interface ExhibitHeaderView : UIView
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIButton *D3Btn;
@property (nonatomic,strong)UIButton *collectBtn;
@property (nonatomic,strong)UIButton *shareBtn;
@property (nonatomic,strong)UILabel *subLB;
@property (nonatomic,strong)UILabel *titleLB;
@property (nonatomic,strong)ExhibitAudioPlayView *audioPlayView;
@property (nonatomic,strong)UICollectionView *autoScrollView;

@property (nonatomic,strong)NSArray<ExhibitThumbModel *> *thumbImgAry;

@property (nonatomic,copy)void(^selectIndexAt)(ExhibitThumbModel*,NSInteger index);

@end

