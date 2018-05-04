//
//  ExhibitFooterView.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentButton;
@class LikeButton;

@interface ExhibitFooterView : UIView
@property (nonatomic,strong)CommentButton *commentBtn;
@property (nonatomic,strong)LikeButton *likeBtn;
@property (nonatomic,strong)UIButton *topBtn;

@end

@interface  CommentButton: UIButton
@property (nonatomic,strong)UILabel *placeLB;
@end

@interface LikeButton : UIButton
@property (nonatomic,assign)BOOL status;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UILabel *countLB;
@end
