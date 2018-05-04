//
//  ExhibitCommentModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ExhibitCommentModel : NSObject

/**
 评论内容
 */
@property (nonatomic,copy)NSString *content;

/**
 用于计算高度的文本
 */
@property (nonatomic,strong)NSAttributedString *cleanContent;

/**
 添加时间
 */
@property (nonatomic,copy)NSString *adddate;

/**
 评论用户ID
 */
@property (nonatomic,copy)NSString *member_comment_id;

/**
 评论用户名称
 */
@property (nonatomic,copy)NSString *username;

/**
 头像
 */
@property (nonatomic,copy)NSString *avatar;

/**
 评论点赞数
 */
@property (nonatomic,copy)NSString *like;


/**
 是否是自己人写的
 */
@property (nonatomic,strong)NSNumber *fake;

/**
 在cell中是否展开
 */
@property (nonatomic,assign)BOOL isOpen;

/**
 是否可以展示关闭按钮
 */
@property (nonatomic,assign)BOOL canShowClose;

@property (nonatomic,strong)NSAttributedString *attributeContent;

/**
 是否已经点赞
 */
@property (nonatomic,assign)BOOL isCmt;

/**
 在cell中的文本高度

 @return 高度
 */
- (CGFloat)cellHeight;
@end
