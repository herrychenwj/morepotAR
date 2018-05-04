//
//  ExhibitInfoModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExhibitCommentModel.h"
@class AudioModel;
@class VideoModel;

@interface ExhibitInfoModel : NSObject


/**
 展品ID
 */
@property (nonatomic,strong)NSString *exhibit_id;


/**
 博物馆ID
 */
@property (nonatomic,strong)NSString *museun_id;


/**
 展厅名称
 */
@property (nonatomic,strong)NSString *exhibition_name;

/**
 位置
 */
@property (nonatomic,strong)NSString *location;

/**
 展品名字
 */
@property (nonatomic,strong)NSString *name;

/**
 size
 */
@property (nonatomic,strong)NSString *size;

/**
 like
 */
@property (nonatomic,strong)NSNumber *like;

/**
 分享链接
 */
@property (nonatomic,strong)NSString *share_url;
/**
 是否收藏
 */
@property (nonatomic,strong)NSNumber *is_favorited;

/**
 图片
 */
@property (nonatomic,strong)NSArray *images;

/**
 音频
 */
@property (nonatomic,strong)NSArray <AudioModel*>*audio;
/**
 视频地址
 */
@property (nonatomic,strong)VideoModel *video;

/**
 3d
 */
@property (nonatomic,strong)NSString *_3d_scale;
/**
 3d链接
 */
@property (nonatomic,strong)NSString *_3d_url;

/**
 介绍
 */
@property (nonatomic,strong)NSString *mDescription;
/**
 富文本介绍
 */
@property (nonatomic,strong)NSAttributedString *attrDescription;

/**
 普通话版的audiourl
 */
@property (nonatomic,strong)NSString *mandarin;


/**
 是否支付
 */
@property (nonatomic,assign)BOOL ispaid;


/**
 评论列表
 */
@property (nonatomic,strong)NSMutableArray <ExhibitCommentModel *>*comments;

/**
 当前页面
 */
@property (nonatomic,strong)NSNumber *page_index;


/**
 方言版的audiourl
 */
@property (nonatomic,strong)NSString *dialect;

@property (nonatomic,assign)BOOL isDescOpen;

- (CGFloat)cellHeight;

@end


@interface AudioModel : NSObject

@property (nonatomic,copy)NSString *audiotype;
@property (nonatomic,copy)NSString *filename;

@end

@interface VideoModel : NSObject

@property (nonatomic,copy)NSString *videourl;
@property (nonatomic,copy)NSString *img;

@end
