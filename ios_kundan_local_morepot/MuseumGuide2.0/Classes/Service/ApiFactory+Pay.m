//
//  ApiFactory+Pay.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/18.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ApiFactory+Pay.h"

@implementation ApiFactory (Pay)

+ (RACSignal *)pay_refreshToken{
    return [[self api_get:API_REFRESHTOKEN params:nil]checkData];
}

+ (RACSignal *)pay_requestOrder:(NSString *)product_id{
    return [self api_post:[PAYMENT_IAP paymentPath] params:@{@"method":@"iap",@"id":product_id}];
}

+ (RACSignal *)pay_verifyIap:(id)params{
    return [self api_post:[PAYMENT_NOTIFY paymentPath] params:params];
}




@end
