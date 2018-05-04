//
//  FileUtil.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/10.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil

/*文件是否存在*/
+ (BOOL)isFileExisted:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[self getFilePath:fileName]]){
        return NO;
    }
    return YES;
}

+ (BOOL)isDirectoryExistsAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if(![fileManager fileExistsAtPath:[self getFilePath:path] isDirectory:&isDir]){
        return NO;
    }
    return YES;
}

/*创建指定名字的文件*/
+ (BOOL)createFileAtPath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSLog(@"-----%@:", path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        return YES;
    }
    
    return NO;
}

/*创建指定名字的文件夹*/
+ (BOOL)createDirectoryAtPath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSLog(@"-----%@:", path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        NSError *error = nil;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        return YES;
    }
    
    return NO;
}

/*得到文件路径*/
+ (NSString *)getFilePath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    return path;
}

+ (NSString *)getDocumentPath {
    NSArray *arrDocumentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentPath=[arrDocumentPaths objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"苏州博物馆"];
    return path;
}

+(void)createDocumentPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建文件夹失败！");
        }
    }
}

+ (void)saveTalkingdata:(NSString*)fileName conent:(NSString*)data
{
    NSString *path = [self getDocumentPath];
    [self createDocumentPath:path];

    NSString *savefilepath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:savefilepath];
    if (result) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:savefilepath];
        [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
        NSString *newstr = [NSString stringWithFormat:@"%@,",data];
        NSData* stringData  = [newstr dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:stringData]; //追加写入数据
        [fileHandle closeFile];
    }
    else{
        NSError *error;
        NSString *newstr = [NSString stringWithFormat:@"%@,",data];

        if([newstr writeToFile:savefilepath atomically:YES encoding:NSUTF8StringEncoding error:&error])
        {
            NSLog(@"------写入文件------success");
        }
        else{
            NSLog(@"error %@",error);
        }
        
    }
}

/*删除文件*/
+ (BOOL)deleteFileAtPath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:path]){
        return NO;
    }
    
    [fileManager removeItemAtPath:path error:nil];
    return YES;
}

@end
