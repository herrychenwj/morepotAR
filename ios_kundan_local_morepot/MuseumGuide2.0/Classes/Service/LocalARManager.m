//
//  LocalARManager.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/5/17.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "LocalARManager.h"
#import <SSZipArchive/SSZipArchive.h>
#import "LocalJsonManager.h"
    
@implementation LocalARManager

+ (void)unzipResourceWithComplete:(void(^)(NSString*))complete{
    //检查本地是否存在
    BOOL is_dir = NO;
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:[zipName stringByDeletingPathExtension]];
    //本地是否存在这个目录
    BOOL  dirExit =[[NSFileManager defaultManager]fileExistsAtPath:path isDirectory:&is_dir];
    if (is_dir && dirExit) { //如果本地已经解压
        if (complete) {
            complete(path);
        }
        return;
    }
    NSString *zipPath = [[NSBundle mainBundle]pathForResource:[zipName stringByDeletingPathExtension] ofType:[zipName pathExtension]];
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:[array firstObject]]) {
        if (complete) {
            complete(path);
        }
        return;
    }
}


@end
