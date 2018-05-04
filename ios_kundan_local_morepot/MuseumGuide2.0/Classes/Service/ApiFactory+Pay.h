//
//  ApiFactory+Pay.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/18.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ApiFactory.h"

@interface ApiFactory (Pay)


+ (RACSignal *)pay_refreshToken;

+ (RACSignal *)pay_requestOrder:(NSString *)product_id;

+ (RACSignal *)pay_verifyIap:(id)params;


@end
