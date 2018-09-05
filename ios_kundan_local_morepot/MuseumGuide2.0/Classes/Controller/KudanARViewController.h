//
//  KudanARViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/5/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KudanAR/KudanAR.h>
#import "MuseumModel.h"

@protocol KudanARDelegate <NSObject>
@optional

/**
 识别到以后回调方法

 @param exhibition_id 展品ID
 @param name 展品名称
 @param arVideo 是否有AR视频
 @param enTitle 是否是英语名称
 */
- (void)kudanOnTrack:(NSString *)exhibition_id Exhibition_name:(NSString *)name hasARVideo:(BOOL)arVideo  enTitle:(BOOL)enTitle;

- (void)kudanOnTrack:(NSString *)exhibition_id Exhibition_names:(NSArray *)names hasARVideo:(BOOL)arVideo  enTitle:(BOOL)enTitle;

- (void)kudanConfigStart;

- (void)kudanConfigEnd;


/**
 丢失识别后回调
 */
- (void)kudanLostTrack;

/**
 视频播放完成回调
 */
- (void)kudanFinishVideo:(NSString *)exhibit_id;
/**
 资源加载完成后
 */
- (void)kudanConfigSuccess;

@end


@interface KudanARViewController : ARCameraViewController


@property (nonatomic,copy)void(^configSuccess)(MuseumModel*);
//资源解压后的地址 设置后自动配置kudan
@property (nonatomic,copy)NSString *resourcePath;
@property (nonatomic,assign)BOOL hiddenLB;

@property (nonatomic,weak)MuseumModel *museum;

@property (nonatomic,weak)id<KudanARDelegate> delegate;

@property (nonatomic,assign)BOOL canEditAR;

@property (nonatomic,assign)BOOL playVideo;


- (BOOL)isARVideoWithExhibitID:(NSString *)exhibit_id;

- (void)hiddenVideo;

- (void)showARVideo:(NSString *)exhibition_id;






@end
