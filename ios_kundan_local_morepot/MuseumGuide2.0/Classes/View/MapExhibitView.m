//
//  MapExhibitView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/2.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MapExhibitView.h"

@interface MapExhibitView ()
@property (nonatomic,strong)UIView *line;
@end

@implementation MapExhibitView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
            collectionView.backgroundColor = [UIColor blackColor];
            collectionView.showsHorizontalScrollIndicator = NO;
            [self addSubview:collectionView];
            collectionView;
        });
        _scrollBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_right"]];
            [btn addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(btn);
                make.width.equalTo(@9);
                make.height.equalTo(@16);
            }];
            [self addSubview:btn];
            btn;
        });
        
        _line = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
            view;
        });
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.bottom.equalTo(self.line.mas_top);
        make.right.equalTo(self.scrollBtn.mas_left);
    }];
    [self.scrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(IPHONE_DEVICE?@60:@100);
        make.right.top.equalTo(self);
        make.bottom.equalTo(self.line.mas_top);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    
}


@end
