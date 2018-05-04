//
//  ExhibitHeaderView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ExhibitHeaderView.h"


@interface ExhibitHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong)NSTimer *t;
@property (nonatomic,strong)UIPageControl *pgControl;
@end
static NSString *const cellID = @"ExhibitThumbImageCell";
@implementation ExhibitHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        _bgView = ({
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectZero];
            bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            bgView.layer.cornerRadius = 8.f;
            [self addSubview:bgView];
            bgView;
        });
        
        _titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:16];
            lb.textColor = [UIColor whiteColor];
            lb.numberOfLines = 2;
            [self addSubview:lb];
            lb;
        });
//        _subLB = ({
//            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
//            lb.font = [UIFont systemFontOfSize:10];
//            lb.textColor = [UIColor whiteColor];
//            [self addSubview:lb];
//            lb;
//        });
        _D3Btn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setImage:[UIImage imageNamed:@"3d"] forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:@"3d_ed"] forState:UIControlStateDisabled];
            [self addSubview:btn];
            btn;
        });
        _collectBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:@"collect_ed"] forState:UIControlStateDisabled];
            [self addSubview:btn];
            btn;
        });
        _shareBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
            [self addSubview:btn];
            btn;
        });
        _audioPlayView = ({
            ExhibitAudioPlayView *playView = [[ExhibitAudioPlayView alloc]initWithFrame:CGRectZero];
            [self addSubview:playView];
            playView;
        });
        _autoScrollView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            layout.minimumLineSpacing = 0.01;
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.pagingEnabled = YES;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.backgroundColor = [UIColor clearColor];
            [collectionView registerClass:[ExhibitThumbImageCell class] forCellWithReuseIdentifier:cellID];
            [self addSubview:collectionView];
            collectionView;
        });
        _pgControl = ({
            UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
            pageControl.currentPageIndicatorTintColor = HexRGB(0xEC6728);
            [self addSubview:pageControl];
            pageControl;
        });
        
        
        @weakify(self);
        [[self.autoScrollView rac_signalForSelector:@selector(layoutSubviews)]subscribeNext:^(id x) {
            @strongify(self);
            UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.autoScrollView.collectionViewLayout;
            layout.itemSize = CGSizeMake(self.autoScrollView.bounds.size.width/2, self.autoScrollView.bounds.size.height);
        }];
        
    }
    return self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        ExhibitThumbModel *firstModel = [self.thumbImgAry firstObject];
    if (firstModel.moiveMode) { //如果第一个是视屏
        if (indexPath.row == 0) { //点了视屏
            if (self.selectIndexAt) {
                self.selectIndexAt(firstModel,indexPath.row);
            }
        }else{
            ExhibitThumbModel *model = [self.thumbImgAry objectAtIndex:indexPath.row];
            if (self.selectIndexAt) {
                self.selectIndexAt(model,indexPath.row -1);
            }
        }
    }else{ //纯图片
        ExhibitThumbModel *model = [self.thumbImgAry objectAtIndex:indexPath.row];
        if (self.selectIndexAt) {
            self.selectIndexAt(model,indexPath.row);
        }
    }
}


- (void)setThumbImgAry:(NSArray<ExhibitThumbModel *> *)thumbImgAry{
    _thumbImgAry = thumbImgAry;
    [self.autoScrollView reloadData];
    if (_thumbImgAry.count > 0 ) {
        if (_t) {
            [_t invalidate];
            _t = nil;
        }
        _t = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoscroll:) userInfo:nil repeats:YES];
    }
    self.pgControl.numberOfPages = _thumbImgAry.count;
    self.pgControl.currentPage = 0;
    
}

- (void)autoscroll:(NSTimer *)timer{
    NSIndexPath *currentIndexPath = [[self.autoScrollView indexPathsForVisibleItems] lastObject];
    NSInteger row = (currentIndexPath.row == _thumbImgAry.count - 1 ) ?0:currentIndexPath.row+1;
     self.pgControl.currentPage = row;
    [self.autoScrollView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row  inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.thumbImgAry.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ExhibitThumbImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    ExhibitThumbModel *model = [self.thumbImgAry objectAtIndex:indexPath.row];
//    [cell.thumbImgView sd_setImageWithURL:[NSURL URLWithString:model.thumbUrl] placeholderImage:kPLACEHOLDERIMAGE];
    cell.thumbImgView.image = [Communtil imageFromlocalpath:model.thumbUrl];
    [cell setMovieMode:model.moiveMode];
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 20));
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self.autoScrollView);
//        make.height.equalTo(@20);
    }];
    [self.subLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB.mas_right).offset(18);
        make.bottom.equalTo(self.titleLB);
    }];
    [self.D3Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_right);
        make.centerY.equalTo(self.autoScrollView.mas_top).offset(8);
        make.width.height.equalTo(IPHONE_DEVICE?@44:@55);
    }];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(self.D3Btn);
        make.centerY.equalTo(self.autoScrollView.mas_centerY).offset(8);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(self.D3Btn);
        make.centerY.equalTo(self.autoScrollView.mas_bottom).offset(8);
    }];
    [self.audioPlayView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.autoScrollView.mas_bottom).offset(8);
        make.left.right.equalTo(self.autoScrollView);
        make.height.equalTo(@30);
            make.bottom.equalTo(self).offset(-12);
    }];
    [self.autoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB);
        make.top.equalTo(self.titleLB.mas_bottom).offset(8);
        make.right.equalTo(self.D3Btn.mas_left).offset(-16);
    }];
    [self.pgControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.autoScrollView);
        make.height.equalTo(@15);
    }];

}

- (void)dealloc{
    [_t invalidate];
    _t = nil;
}



@end



