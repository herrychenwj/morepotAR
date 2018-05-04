//
//  ApiFactory+Mine.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/15.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ApiFactory+Mine.h"
#import <MJExtension/MJExtension.h>
#import "AppDelegate+Conf.h"

@implementation ApiFactory (Mine)

+ (RACSignal *)mine_feedback:(id)params{
    return [[self api_post:API_FEEDBACK.apiPath params:params]checkData];
}

+ (RACSignal *)mine_getUserInfo{
    return [[self api_get:API_USERCENTER.apiPath params:nil]checkData];
}

+ (RACSignal *)mine_login:(id)params{
    return [[self api_post:API_LOGIN.apiPath params:params]checkData];
}

+ (RACSignal *)mine_syncFavorite:(id)params{
    return [[self api_get:API_EXHIBITFAV.apiPath params:params]checkData];
}

+ (RACSignal *)mine_editGender:(NSString *)gender{
    return [[self api_put:API_EDITGENDER.apiPath params:@{@"sexstr":gender?:@""}]checkData];;
}

+ (RACSignal *)mine_editSignature:(NSString *)content{
    return [[self api_put:API_EDITSIGNAL.apiPath params:@{@"content":content?:@""}]checkData];;
}

+ (RACSignal *)mine_editNickName:(NSString *)nickName{
    return [[self api_put:API_EDITNICKNAME.apiPath params:@{@"nickname":nickName?:@""}]checkData];
}

+ (RACSignal *)mine_editBirthday:(NSNumber *)birthDaty{
    return [[self api_put:API_EDITBIRTH.apiPath params:@{@"birthstr":birthDaty?:@""}]checkData];}

+ (RACSignal *)mine_getFavortieExhibits{
    return [[self api_get:API_EXHIBITFAV.apiPath params:nil]checkData];
}

+ (RACSignal *)mine_getFootprintExhibits{
    return [[self api_get:API_EXHIBITFOOT.apiPath params:nil]checkData];
}


+ (RACSignal *)mine_getComments{
    return [[self api_get:API_MYCMTS.apiPath params:nil]checkData];
}


+ (RACSignal *)mine_editAvatar:(NSData *)imgData{
    return [[self api_uploadImage:imgData url:API_EDITAVATAR.apiPath]checkData];
}

+ (RACSignal *)mine_bindPhone:(id)params{
    return [[self api_put:API_BINDPHONE.apiPath params:params] checkData];
}

+ (RACSignal *)mine_getAuthCode:(NSString *)phoneNum{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *params = @{@"mobile":phoneNum?:@"",@"temp_id":@"1"};
        NSData *postData = [params mj_JSONData];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSString *base64 = [[[NSString stringWithFormat:@"%@:%@",JPushKey,JPushMaster] dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:JSMS_URL parameters:nil error:nil];
        request.timeoutInterval= 20.f;
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:[NSString stringWithFormat:@"Basic %@",base64] forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:postData];
        [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                NSString *msg_id = [responseObject objectForKey:@"msg_id"];
                if (msg_id) {
                    [subscriber sendNext:msg_id];
                    [subscriber sendCompleted];
                }else{
                    [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:@"发送失败"]];
                }
            } else {
                [subscriber sendError:error];
            }
        }] resume];
        return nil;
    }];
}
@end
