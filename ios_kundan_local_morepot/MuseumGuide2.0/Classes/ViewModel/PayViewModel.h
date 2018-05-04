//
//  PayViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/6/16.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

#import <StoreKit/StoreKit.h>

@protocol IapDelegate <NSObject>

@optional;
/**
 Iap支付成功

 @param transaction
 */
- (void)completeTransaction:(SKPaymentTransaction *)transaction;


- (void)restoreTransaction:(SKPaymentTransaction *)transaction;


/**
 iap支付失败

 @param transaction <#transaction description#>
 */
- (void)failedTransaction:(SKPaymentTransaction *)transaction;


@end

@interface PayViewModel : BaseViewModel

//应用内支付
@property (nonatomic,strong,readonly)RACCommand *iapCmd;

@property (nonatomic,strong,readonly)RACCommand *tokenCmd;

@property (nonatomic,weak)id<IapDelegate>  delegate;


@property (nonatomic,copy)NSString *product_id;

@property (nonatomic,assign)BOOL showHUD;

@property (nonatomic,copy)NSString *errorMsg;


@end
