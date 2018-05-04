//
//  MuseumInfoTextTableViewCell.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYLabel.h"

typedef void(^ReloadBlock)();
@interface MuseumInfoTextTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasMore:(BOOL)hasMore;
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndisMuseumCell:(BOOL)museumCell;
@property (nonatomic,strong)YYLabel *contentLB;
@property (nonatomic,strong)UIButton *closeBtn;


@property (nonatomic,copy)ReloadBlock reload;

- (void)addSeeMoreButton;

@end
