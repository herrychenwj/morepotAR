//
//  FileUtil.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/10.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject
/**
 文件是否存在

 @param fileName 文件名
 @return  文件是否存在
 */
+ (BOOL)isFileExisted:(NSString *)fileName;

/**
 文件夹是否存在

 @param path 文件夹路径
 @return 文件夹是否存在
 */
+ (BOOL)isDirectoryExistsAtPath:(NSString *)path;
/*创建指定名字的文件*/
+ (BOOL)createFileAtPath:(NSString *)fileName;
/*创建指定名字的文件夹*/
+ (BOOL)createDirectoryAtPath:(NSString *)fileName;
/*得到文件路径*/
+ (NSString *)getFilePath:(NSString *)fileName;
/*删除文件*/
+ (BOOL)deleteFileAtPath:(NSString *)fileName;

+ (void)saveTalkingdata:(NSString*)fileName conent:(NSString*)data;
@end
