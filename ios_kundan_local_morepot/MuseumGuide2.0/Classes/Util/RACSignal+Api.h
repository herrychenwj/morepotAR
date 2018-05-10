//
//  RACSignal+Api.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/15.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <MJRefresh/MJRefresh.h>


@interface RACSignal(Api)


- (RACSignal *_Nullable)checkData;

- (RACSignal *_Nullable)autoRefresh:(MJRefreshComponent *_Nullable)tbRefresh;

- (RACSignal *_Nullable)autoPlaySound;


- (RACSignal *_Nullable)autoHUD:(UIView *_Nullable)showView;

- (RACSignal *_Nullable)showErrorMsgTo:(UIView *_Nullable)showView;

@end
