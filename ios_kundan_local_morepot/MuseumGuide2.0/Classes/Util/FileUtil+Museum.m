//
//  FileUtil+Museum.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/12.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "FileUtil+Museum.h"
//mp3文件保存路径
#define MP3PATH  @"mp3"
//AR资源保存路径
#define ARPATH @"ar"
//SVG资源保存路径
#define SVGPATH  @"svg"
//根路径
#define MUSEUMPATH  @"museumguide"

@implementation FileUtil (Museum)

+ (NSString *)museumRootDir{
    return MUSEUMPATH;
}

+ (NSString *)docWithType:(FilePathType)fileType{
    NSString *pathStr;
    switch (fileType) {
        case AR_FILEPATH:
            pathStr = @"ar";
            break;
        case SVG_FILEPATH:
            pathStr = @"svg";
            break;
        case MP3_FILEPATH:
            pathStr = @"mp3";
            break;
        default:
            break;
    }
    return pathStr;
}

+ (NSString *)pathWithFile:(FilePathType)fileType museum_id:(NSString *)museum_id{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",MUSEUMPATH,museum_id,[self docWithType:fileType]];
    return [self fileDocument:path];
}


+ (NSString *)cache:(FilePathType)fileType museum_id:(NSString *)museum_id fileURL:(NSString *)fileURL{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",MUSEUMPATH,museum_id,[self docWithType:fileType]];
    NSString *doc = [fileURL lastPathComponent];
    return [path stringByAppendingPathComponent:doc];
}


+ (NSString *)fileDocument:(NSString *)path{
    if (![self isDirectoryExistsAtPath:path]) {
        [self createDirectoryAtPath:path];
    }
    return [self getFilePath:path];
}




@end
