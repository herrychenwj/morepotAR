//
//  RootViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "RootViewModel.h"
#import <SSZipArchive/SSZipArchive.h>
#import "MuseumListModel.h"
#import "FileUtil+Museum.h"
#import "MuseumModel.h"
#import "DownloadFactory.h"
#import "ApiFactory+Tour.h"

@interface RootViewModel ()
@property (nonatomic,strong,readwrite)RACCommand *museumListCmd;
@property (nonatomic,strong,readwrite)RACCommand *loadARCmd;
@end

@implementation RootViewModel


- (RACCommand *)museumListCmd{
    if (!_museumListCmd) {
        @weakify(self);
        _museumListCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[[ApiFactory tour_museumlist:self.gpsInfo]autoRefresh:input]showErrorMsgTo:self.hudView] map:^id(id value) {
                MuseumListModel *tmp = [MuseumListModel mj_objectWithKeyValues:value];
                tmp.culture = [[tmp.culture.rac_sequence map:^id(MuseumModel *value) {
                    value.isCalure = YES;
                    return value;
                }] array];
                return tmp;
            }];
        }];
    }
    return _museumListCmd;
}


- (RACCommand *)loadARCmd{
    if (!_loadARCmd) {
        @weakify(self);
        _loadARCmd =  [[RACCommand alloc]initWithSignalBlock:^RACSignal *(MuseumModel *input) {
            NSString *savePath = [FileUtil pathWithFile:AR_FILEPATH museum_id:input.museum_id];
            NSString *filePath = [input cacheResourceDir];
            NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:filePath];
            BOOL fileExits = [Communtil localARResourceReady:input.museum_id savePath:path md5:input.zip_md5];
            return fileExits?[RACSignal return:input]:[[[[[[DownloadFactory downloadWith:[input.resourceurl cloudPath] savePath:savePath  progress:^(NSProgress *downloadProgress) {
                @strongify(self);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.downloadProgress = downloadProgress.fractionCompleted;
                });
            }]flattenMap:^RACStream *(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    if ([SSZipArchive unzipFileAtPath:value toDestination:savePath]){ //解压完成
                        //删除资源
                        [[NSFileManager defaultManager] removeItemAtPath:value error:nil];
                        [[NSUserDefaults standardUserDefaults]setObject:input.zip_md5 forKey:kARRESOURCE_MD5(input.museum_id)];
                        [subscriber sendNext:input];
                        [subscriber sendCompleted];
                    }else{
                        //删除资源
                        [[NSFileManager defaultManager] removeItemAtPath:value error:nil];
                        [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:[TXSakuraManager tx_stringWithPath:@"unzipfaild"]]];
                    };
                    return nil;
                }];
            }] showErrorMsgTo:self.hudView]initially:^{
                @strongify(self);
                self.showProgress = YES;
                self.downloadProgress = 0.0;
            }]doError:^(NSError *error) {
                @strongify(self);
                self.showProgress = NO;
            }]finally:^{
                @strongify(self);
                self.showProgress = NO;
            }];
            return nil;
        }];

    }
    return _loadARCmd;
}









@end
