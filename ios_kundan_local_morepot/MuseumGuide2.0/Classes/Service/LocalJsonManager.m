//
//  LocalJsonManager.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2018/3/5.
//  Copyright © 2018年 Heyunguanbo. All rights reserved.
//

#import "LocalJsonManager.h"
#import <SSZipArchive/SSZipArchive.h>

@implementation LocalJsonManager


+ (void)unzipJsonswithComplete:(void(^)())complete{
    //检查本地是否存在
    BOOL is_dir = NO;
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:[@"local_api" stringByDeletingPathExtension]];
    //本地是否存在这个目录
    BOOL  dirExit =[[NSFileManager defaultManager]fileExistsAtPath:path isDirectory:&is_dir];
    if (is_dir && dirExit) { //如果本地已经解压
        if (complete) {
            complete(path);
        }
        return;
    }
    NSString *zipPath = [[NSBundle mainBundle]pathForResource:[jsonsName stringByDeletingPathExtension] ofType:[jsonsName pathExtension]];
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:[array firstObject]]) {
        if (complete) {
            complete(path);
        }
        return;
    }
}


+ (RACSignal *)rac_getExhibitionInfo:(NSString *)exhibit_id{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [self unzipJsonswithComplete:^{
            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"localApi" ofType:@"bundle"];
//            NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *expathPath = [NSString stringWithFormat:@"%@/%@/%@",bundlePath,exhibitionPath,[NSString stringWithFormat:@"%@.json",exhibit_id]];
            NSDictionary *responseObject = [Communtil readlocalJsonFile:expathPath];
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
//            if ([responseObject isKindOfClass:[NSDictionary class]] &&  [[responseObject objectForKey:@"reponsecode"] isEqual:@0]) {
//                [subscriber sendNext:[responseObject objectForKey:@"data"]];
//                [subscriber sendCompleted];
//            }else{
//                if ([[responseObject objectForKey:@"reponsecode"] isEqual:@1000]) { //token失效 执行退出操作
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kACCESS_TOKEN];
//                }
//                NSString *error = [responseObject objectForKey:@"reponsemessage"];
//                [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:error]];
//            }
//        }];
        return nil;
    }];
}



+ (RACSignal *)rac_getlocalApi:(NSString *)jsonName folder:(NSString *)folderName{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [self unzipJsonswithComplete:^{
            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"localApi" ofType:@"bundle"];

//            NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *expathPath = [NSString stringWithFormat:@"%@/%@/%@",bundlePath,folderName,[NSString stringWithFormat:@"%@.json",jsonName]];
            NSDictionary *responseObject = [Communtil readlocalJsonFile:expathPath];
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
//            if ([responseObject isKindOfClass:[NSDictionary class]] &&  [[responseObject objectForKey:@"reponsecode"] isEqual:@0]) {
//
//            }else{
//                if ([[responseObject objectForKey:@"reponsecode"] isEqual:@1000]) { //token失效 执行退出操作
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kACCESS_TOKEN];
//                }
//                NSString *error = [responseObject objectForKey:@"reponsemessage"];
//                [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:error]];
//            }
//        }];
        return nil;
    }];
}


@end
