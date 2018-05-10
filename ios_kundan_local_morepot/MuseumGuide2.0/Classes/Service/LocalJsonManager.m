//
//  LocalJsonManager.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2018/3/5.
//  Copyright © 2018年 Heyunguanbo. All rights reserved.
//

#import "LocalJsonManager.h"

@implementation LocalJsonManager


//+ (void)unzipJsonswithComplete:(void(^)())complete{
//    //检查本地是否存在
//    BOOL is_dir = NO;
//    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:[@"local_api" stringByDeletingPathExtension]];
//    //本地是否存在这个目录
//    BOOL  dirExit =[[NSFileManager defaultManager]fileExistsAtPath:path isDirectory:&is_dir];
//    if (is_dir && dirExit) { //如果本地已经解压
//        if (complete) {
//            complete(path);
//        }
//        return;
//    }
//    NSString *zipPath = [[NSBundle mainBundle]pathForResource:[jsonsName stringByDeletingPathExtension] ofType:[jsonsName pathExtension]];
//    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:[array firstObject]]) {
//        if (complete) {
//            complete(path);
//        }
//        return;
//    }
//}


+ (RACSignal *)rac_getExhibitionInfo:(NSString *)exhibit_id{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"localApi" ofType:@"bundle"];
            NSString *expathPath = [NSString stringWithFormat:@"%@/%@/%@",bundlePath,exhibitionPath,[NSString stringWithFormat:@"%@.json",exhibit_id]];
            NSDictionary *responseObject = [Communtil readlocalJsonFile:expathPath];
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        return nil;
    }];
}



+ (RACSignal *)rac_getlocalApi:(NSString *)jsonName folder:(NSString *)folderName{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"localApi" ofType:@"bundle"];
            NSString *expathPath = [NSString stringWithFormat:@"%@/%@/%@",bundlePath,folderName,[NSString stringWithFormat:@"%@.json",jsonName]];
            NSDictionary *responseObject = [Communtil readlocalJsonFile:expathPath];
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        return nil;
    }];
}


@end
