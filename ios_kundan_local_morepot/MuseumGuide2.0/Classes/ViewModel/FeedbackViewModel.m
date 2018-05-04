//
//  FeedbackViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/30.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "FeedbackViewModel.h"
#import "ApiFactory+Mine.h"

@interface FeedbackViewModel ()

@property (nonatomic,strong,readwrite)RACCommand *submitCmd;

@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)RACSignal *contentSignal;
@property (nonatomic,strong)RACSignal *contactSignal;

@end
@implementation FeedbackViewModel


- (RACSignal *)contactSignal{
    if (!_contactSignal) {
        _contactSignal = RACObserve(self, contact);
    }
    return _contactSignal;
}

- (RACSignal *)contentSignal{
    if (!_contentSignal) {
        _contentSignal = RACObserve(self, content);
    }
    return _contentSignal;
}


- (RACCommand *)submitCmd{
    if (!_submitCmd) {
        @weakify(self);
        _submitCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[self enableSignal]flattenMap:^RACStream *(id value) {
                @strongify(self);
                return [value boolValue] ? [[ApiFactory mine_feedback:@{@"contact":self.contact?:@"",@"content":self.content?:@"",@"type":@"phone"}]showErrorMsgTo:self.hudView]:[[RACSignal error:[NSErrorHelper  createErrorWithErrorInfo:[TXSakuraManager tx_stringWithPath:@"pleasephone"]]] showErrorMsgTo:self.hudView];
            }];
        }];
    }
    return _submitCmd;
}


- (RACSignal *)enableSignal{
    return [RACSignal combineLatest:@[self.contactSignal,self.contentSignal] reduce:^id(NSString *contact,NSString *content) {
        return @(content.length > 0 && ([Communtil validateEmail:contact]||([Communtil isPureInt:contact]&&contact.length == 11)));
    }];
}



@end
