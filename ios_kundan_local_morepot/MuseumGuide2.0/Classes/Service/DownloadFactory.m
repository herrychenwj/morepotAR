//
//  DownloadFactory.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/15.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "DownloadFactory.h"
#import "FileUtil+Museum.h"


@implementation DownloadFactory


+ (AFHTTPSessionManager *)downloadManager{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager =  [AFHTTPSessionManager manager];
    });
    return manager;
}

#pragma mark download
+ (void)suspendDownloadTask{
    for (NSURLSessionDownloadTask *task in [self downloadManager].downloadTasks) {
        [task suspend];
    }
}

+ (void)resumeDownloadTask{
    for (NSURLSessionDownloadTask *task in [self downloadManager].downloadTasks) {
        [task resume];
    }
}

+ (void)cancelDownloadTask{
    for (NSURLSessionDownloadTask *task in [self downloadManager].downloadTasks) {
        [task cancel];
    }
}



+ (RACSignal *)cacheSVGWithUrl:(NSString *)url  museum_id:(NSString *)museum_id{
    return [self cacheSignalWithUrl:url  museum_id:museum_id fileType:SVG_FILEPATH];
}

+ (RACSignal *)cacheMP3WithUrl:(NSString *)url  museum_id:(NSString *)museum_id{
    return [self cacheSignalWithUrl:url  museum_id:museum_id fileType:MP3_FILEPATH];
}

+ (RACSignal *)cacheSignalWithUrl:(NSString *)url museum_id:(NSString *)museum_id fileType:(FilePathType)fileType{
    NSString *realPath = [FileUtil cache:fileType museum_id:museum_id fileURL:url];
    NSString *savePath = [FileUtil pathWithFile:fileType museum_id:museum_id];
    return  [FileUtil isFileExisted:realPath] ? [RACSignal return:[FileUtil getFilePath:realPath]]:[self  downloadWith:url savePath:savePath progress:nil];
}





+ (RACSignal *)downloadWith:(NSString *)url savePath:(NSString *)savePath progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *filePath =  [savePath stringByAppendingPathComponent:[url lastPathComponent]];
        [[[self downloadManager] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:filePath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (!error) {
                [subscriber sendNext:[filePath path]];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:[TXSakuraManager tx_stringWithPath:@"cancel"]]];
            }
        }] resume];
        return nil;
    }];
}
@end
