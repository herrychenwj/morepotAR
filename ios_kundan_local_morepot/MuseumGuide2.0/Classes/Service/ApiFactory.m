//
//  ApiFactory.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/14.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ApiFactory.h"

@implementation ApiFactory

+ (AFHTTPSessionManager *)ApiManager{
    static AFHTTPSessionManager *manager;
    manager =  [AFHTTPSessionManager manager];
    [manager defaultConf];
    [manager autoConf];
    return manager;
}

+ (RACSignal *)api_get:(NSString *)url params:(id)params{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self ApiManager] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:@"未知错误"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

+ (RACSignal *)api_post:(NSString *)url params:(id)params{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self ApiManager]  POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:@"未知错误"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

+ (RACSignal *)api_put:(NSString *)url params:(id)params{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self ApiManager]  PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:@"未知错误"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

+ (RACSignal *)api_uploadImage:(NSData *)imgData url:(NSString *)url{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self ApiManager] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imgData name:@"imgdata" fileName:[NSString stringWithFormat:@"%.f.png",[NSDate timeIntervalSinceReferenceDate]] mimeType:@"image/png"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:@"上传失败"]];
        }];
        return nil;
    }];
}

@end


@implementation AFHTTPSessionManager(Api)


- (void)defaultConf{
    self.requestSerializer.timeoutInterval = 20.f;
    [self.requestSerializer setValue:[Communtil app_versionNumber] forHTTPHeaderField:@"appversion"];
    [self.requestSerializer setValue:[Communtil app_deviceId] forHTTPHeaderField:@"deviceid"];
    [self.requestSerializer setValue:[Communtil app_systemVersion] forHTTPHeaderField:@"osversion"];
    [self.requestSerializer setValue:@"yunguanbo" forHTTPHeaderField:@"appname"];
    [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"ostype"];
    [self.requestSerializer setValue:[Communtil iphoneType] forHTTPHeaderField:@"devicetype"];
//    [self.requestSerializer setValue:@"metaio" forHTTPHeaderField:@"apptype"];
    [self.requestSerializer setValue:@"kudan" forHTTPHeaderField:@"apptype"];

}

- (void)autoConf{
    [self.requestSerializer setValue:[Communtil app_language] forHTTPHeaderField:@"language"];
    [self.requestSerializer setValue:[Communtil app_networkType] forHTTPHeaderField:@"networktype"];
    [self.requestSerializer setValue:[Communtil token] forHTTPHeaderField:@"token"];
}

@end
