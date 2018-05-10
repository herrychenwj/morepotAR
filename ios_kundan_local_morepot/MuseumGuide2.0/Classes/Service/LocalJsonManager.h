//
//  LocalJsonManager.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2018/3/5.
//  Copyright © 2018年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const exhibitionPath = @"local_api/exhibit";
static NSString *const commentPath = @"local_api/comment";
static NSString *const museumPath = @"local_api";
static NSString *const resourcePath = @"local_api";

@interface LocalJsonManager : NSObject

+ (RACSignal *)rac_getExhibitionInfo:(NSString *)exhibit_id;


/**
 本地json文件调用
 
 @param exhibit_id 展品ID
 @param folderName api所在目录
 */
+ (RACSignal *)rac_getlocalApi:(NSString *)exhibit_id folder:(NSString *)folderName;


//+ (void)unzipJsonswithComplete:(void(^)())complete;

@end
