//
//  AdvertisementView.m
//  PRO_TEST
//
//  Created by Mr.Huang on 2017/7/13.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import "AdvertisementView.h"
#import <Masonry/Masonry.h>


@interface AdvertisementView ()
@property (nonatomic,strong)UIView *bgView;

@end

@implementation AdvertisementView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        _bgView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            view.layer.cornerRadius = 8.f;
            [self addSubview:view];
            view;
        });
        _bannerView = ({
            SDCycleScrollView *banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder"]];
            banner.titleLabelTextAlignment = NSTextAlignmentLeft;
            banner.titleLabelHeight = 30.f;
            banner.titleLabelBackgroundColor = HexRGBAlpha(0x000000, 0.7);
            banner.titleLabelTextColor = [UIColor whiteColor];
            banner.pageControlBottomOffset = -25.f;
            banner.pageControlRightOffset = -9;
            banner.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            banner.currentPageDotColor = HexRGB(0xEC6728);
            banner.pageDotColor = [UIColor whiteColor];
            banner.showPageControl = YES;
            banner.autoScrollTimeInterval = 4.f;
            [self.bgView addSubview:banner];
            banner;
        });
        _titleLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = [UIColor whiteColor];
            [self.bgView addSubview:label];
            label;
        });
        _pageControl = ({
            UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectZero];
            page.currentPageIndicatorTintColor = HexRGB(0xEC6728);
            page.pageIndicatorTintColor = [UIColor lightGrayColor];
            page;
        });
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(22);
        make.right.equalTo(self).offset(-22);
        make.top.bottom.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(16);
        make.top.equalTo(self.bgView).offset(8);
        make.height.equalTo(@20);
    }];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.bottom.equalTo(self).offset(-16);
        make.right.equalTo(self.bgView).offset(-16);
    }];

}




@end
