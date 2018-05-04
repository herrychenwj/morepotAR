//
//  DownloadFactory.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/15.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


@interface DownloadFactory : NSObject

/**
 暂停下载
 */
+ (void)suspendDownloadTask;

/**
 恢复下载
 */
+ (void)resumeDownloadTask;

/**
 取消下载
 */
+ (void)cancelDownloadTask;

+ (RACSignal *)downloadWith:(NSString *)url savePath:(NSString *)savePath progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock;

+ (RACSignal *)cacheSVGWithUrl:(NSString *)url  museum_id:(NSString *)museum_id;

+ (RACSignal *)cacheMP3WithUrl:(NSString *)url  museum_id:(NSString *)museum_id;


@end
