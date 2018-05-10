//
//  RACSignal+Api.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/15.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "RACSignal+Api.h"
#import "MBProgressHUD+Add.h"

@implementation RACSignal(Api)

- (RACSignal *)autoPlaySound{
    return [self doNext:^(id x) {
        [Communtil playClickSound];
    }];
}


- (RACSignal *)checkData{
    return  [self flattenMap:^RACStream *(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if ([[value objectForKey:@"reponsecode"] isEqual:@0]) {
                [subscriber sendNext:[value objectForKey:@"data"]];
                [subscriber sendCompleted];
            }else if ([[value objectForKey:@"reponsecode"] isEqual:@1000]){
                //执行退出操作
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kACCESS_TOKEN];
            }
            NSString *resp = [value objectForKey:@"reponsemessage"];
            [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:resp]];
            return nil;
        }];
    }];
}

- (RACSignal *)autoRefresh:(MJRefreshComponent *)tbRefresh{
    return [[[self initially:^{
        [tbRefresh beginRefreshing];
    }]doCompleted:^{
        [tbRefresh endRefreshing];
    }]doError:^(NSError *error) {
        [tbRefresh endRefreshing];
    }];
}

- (RACSignal *)autoHUD:(UIView *)showView{
    return [[[self initially:^{
        [MBProgressHUD showHUDAddedTo:showView animated:YES];
    }]doCompleted:^{
        [MBProgressHUD hideHUDForView:showView animated:YES];
    }]doError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:showView animated:YES];
    }];
}

- (RACSignal *)showErrorMsgTo:(UIView *)showView{
    return [self doError:^(NSError *error) {
        [MBProgressHUD showMessag:[NSErrorHelper handleErrorMessage:error] toView:showView];
    }];
}




@end

