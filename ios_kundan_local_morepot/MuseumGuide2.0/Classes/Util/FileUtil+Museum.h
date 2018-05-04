//
//  FileUtil+Museum.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/12.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "FileUtil.h"

typedef NS_ENUM(NSInteger,FilePathType){
    //AR资源存放路径
    AR_FILEPATH = 0,
    //svg地图存放路径
    SVG_FILEPATH,
    //MP3文件存放路径
    MP3_FILEPATH
};
@interface FileUtil (Museum)
/**
 缓存AR资源的位置，文件夹
 用于检测本地是否已经有了AR资源的文件夹
 @param museum_id 博物馆ID
 @param fileURL 资源下载链接(zip包名必须和解压出来的文件夹名字相同)
 @return 本地缓存的路径
 */
+ (NSString *)cache:(FilePathType)fileType museum_id:(NSString *)museum_id fileURL:(NSString *)fileURL;


/**
 根据博物馆ID获取各类文件缓存路径

 @param fileType 文件类型
 @param museum_id 博物馆ID
 @return 文件夹路径
 */
+ (NSString *)pathWithFile:(FilePathType)fileType museum_id:(NSString *)museum_id;


/**
 自动拼接文件夹路径(如果没有文件夹自动创建)

 @param path 拼接路径
 @return  文件夹绝对路径
 */
+ (NSString *)fileDocument:(NSString *)path;

+ (NSString *)museumRootDir;


@end
