//
//  NewsModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

/**
 ID
 */
@property (nonatomic,copy)NSString *museum_news_id;
/**
 博物馆名称
 */
@property (nonatomic,copy)NSString *museum_name;
/**
 标题
 */
@property (nonatomic,copy)NSString *title;
/**
 图片
 */
@property (nonatomic,copy)NSString *picture;
/**
 评论内容
 */
@property (nonatomic,copy)NSString *content;
/**
 创建日期
 */
@property (nonatomic,copy)NSString *createdate;


/**
 调整行间距后的文字
 */
@property (nonatomic,strong)NSAttributedString *attrTitle;





@property (nonatomic,copy)NSString *url;


@end
