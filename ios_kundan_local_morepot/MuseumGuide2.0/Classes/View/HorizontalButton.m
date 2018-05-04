
//
//  HorizontalButton.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/10/24.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "HorizontalButton.h"
@interface HorizontalButton()
@property (nonatomic,strong)UILabel *horizontalLabel;
@end

@implementation HorizontalButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _horizontalLabel = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:21];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 2;
            [self addSubview:label];
            label;
        });
    }
    return self;
}

- (void)setHorizaontalTitle:(NSString *)horizaontalTitle{
    _horizaontalTitle = horizaontalTitle;
    self.horizontalLabel.text = _horizaontalTitle;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.horizontalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        make.top.bottom.equalTo(self);
    }];
}






@end
