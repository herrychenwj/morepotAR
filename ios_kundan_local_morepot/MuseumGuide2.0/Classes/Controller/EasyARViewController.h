//
//  EasyARViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/10/26.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "MuseumModel.h"

@protocol EasyARDelegate <NSObject>
@optional

/**
 识别到以后回调方法
 
 @param exhibition_id 展品ID
 @param name 展品名称
 @param arVideo 是否有AR视频
 @param enTitle 是否是英语名称
 */
- (void)easyOnTrack:(NSString *)exhibition_id Exhibition_name:(NSString *)name hasARVideo:(BOOL)arVideo  enTitle:(BOOL)enTitle;

/**
 丢失识别后回调
 */
- (void)easyLostTrack;

/**
 视频播放完成回调
 */
- (void)easyFinishedVideo;


@end

@protocol ARDelegate <NSObject>
@optional

/**
 识别到以后回调方法
 
 @param exhibition_id 展品ID
 @param name 展品名称
 @param arVideo 是否有AR视频
 @param enTitle 是否是英语名称
 */
- (void)onTrack:(NSString *)exhibition_id Exhibition_name:(NSString *)name hasARVideo:(BOOL)arVideo  enTitle:(BOOL)enTitle;

- (void)onTrack:(NSString *)exhibition_id Exhibition_names:(NSArray *)names hasARVideo:(BOOL)arVideo  enTitle:(BOOL)enTitle;

- (void)configStart;

- (void)configEnd;


/**
 丢失识别后回调
 */
- (void)lostTrack;

/**
 视频播放完成回调
 */
- (void)finishVideo:(NSString *)exhibit_id;

@end


@interface EasyARViewController : GLKViewController

@property (nonatomic,copy)void(^configSuccess)(MuseumModel*);
//资源解压后的地址 设置后自动配置kudan
@property (nonatomic,copy)NSString *resourcePath;
@property (nonatomic,assign)BOOL hiddenLB;

@property (nonatomic,weak)MuseumModel *museum;

@property (nonatomic,weak)id<ARDelegate> arDelegate;

@property (nonatomic,assign)BOOL canEditAR;

@property (nonatomic,assign)BOOL playVideo;

- (BOOL)isARVideoWithExhibitID:(NSString *)exhibit_id;

- (void)hiddenVideo;

- (void)showARVideo:(NSString *)exhibition_id;
@end
