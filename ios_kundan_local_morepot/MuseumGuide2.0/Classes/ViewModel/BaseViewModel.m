//
//  BaseViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewModel.h"
#import "ExhibitInfoModel.h"
#import "ApiFactory+Tour.h"

@interface BaseViewModel ()
@property (nonatomic,strong,readwrite)RACCommand *exhibitInfoCmd;
@property (nonatomic,strong,readwrite)RACCommand *reloadCmtCmd;

@end

@implementation BaseViewModel

- (instancetype)initWithHUDShowView:(UIView *)view{
    if (self = [self init]) {
        self.hudView = view;
    }
    return self;
}


#pragma mark lazy load
- (RACCommand *)exhibitInfoCmd{
    if (!_exhibitInfoCmd) {
        @weakify(self);
        _exhibitInfoCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[RACSignal combineLatest:@[[ApiFactory tour_exhibitInfo:input?:@""],[ApiFactory tour_exhibitCmtlist:input?:@"" pageIndex:0]] reduce:^(NSDictionary *exhibit,NSDictionary *cmtData){
                NSMutableDictionary *dic = [exhibit mutableCopy];
                if (cmtData && [cmtData objectForKey:@"comments"]) {
                    dic[@"comments"] = [cmtData objectForKey:@"comments"];
                }
                return [ExhibitInfoModel mj_objectWithKeyValues:[dic copy]];
            }]showErrorMsgTo:self.hudView];
        }];
    }
    return _exhibitInfoCmd;
}







@end
