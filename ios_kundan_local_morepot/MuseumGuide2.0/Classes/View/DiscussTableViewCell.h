//
//  DiscussTableViewCell.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYLabel.h"
#import "ExhibitCommentModel.h"

typedef void(^ReloadBlock)();
@interface DiscussTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *nameLB;
@property (nonatomic,strong)UIButton *supportBtn;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)YYLabel *contentLB;

@property (nonatomic,copy)ReloadBlock reload;

- (void)setComment:(ExhibitCommentModel *)cmt;


@end
