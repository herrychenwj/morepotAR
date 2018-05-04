//
//  PayViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/6/16.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "PayViewModel.h"
#import "MBProgressHUD+Add.h"
#import "PayMainView.h"
#import "YYText.h"
#import "ApiFactory+Pay.h"


@interface PayViewModel ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,strong,readwrite)RACCommand *iapCmd;
@property (nonatomic,strong,readwrite)RACCommand *tokenCmd;
@end

@implementation PayViewModel

-(instancetype)init{
    if (self = [super init]) {
        @weakify(self);
        self.showHUD = NO;
        self.tokenCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [[ApiFactory pay_refreshToken]flattenMap:^RACStream *(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSString *token = [value objectForKey:@"token"];
                    if (token && token.length > 0 ) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kACCESS_TOKEN];
                        [[NSUserDefaults standardUserDefaults]setObject:token forKey:kACCESS_TOKEN];
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }
                    [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:@"支付错误，请重新登录"]];
                    return nil;
                }];
            }];
        }];
        self.iapCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[[ApiFactory pay_requestOrder:self.product_id]flattenMap:^RACStream *(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSString *result = [value objectForKey:@"id"];
                    @strongify(self);
                    if (result && result.length > 0 && [SKPaymentQueue canMakePayments]) {
                        self.showHUD = YES;
                        self.order_id = result;
                        NSArray *product = [[NSArray alloc] initWithObjects:self.product_id,nil];
                        NSSet *nsset = [NSSet setWithArray:product];
                        SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
                        request.delegate=self;
                        [request start];
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }else{
                        self.errorMsg = @"订单处理失败";
                    }
                    return nil;
                }];
            }]showErrorMsgTo:self.hudView] skip:1];
        }];
        
        
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[self rac_signalForSelector:@selector(productsRequest:didReceiveResponse:) fromProtocol:@protocol(SKProductsRequestDelegate)]subscribeNext:^(RACTuple *x) {
            SKProductsResponse *response = x[1];
            NSArray *myProduct = response.products;
            SKPayment *payment;
            if (myProduct.count > 0) {
                payment = [SKPayment paymentWithProduct:[myProduct firstObject]];
            }
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }];
    }
    return self;
}



- (void)requestProUpgradeProductData{
    NSLog(@"------请求升级数据---------");
    self.showHUD = NO;
    NSSet *productIdentifiers = [NSSet setWithObject:self.product_id];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}



//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    self.showHUD = NO;
    self.errorMsg = @"购买出错";
}

-(void) requestDidFinish:(SKRequest *)request{
    NSLog(@"----------反馈信息结束--------------");
    
}

-(void)PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}

//----监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchased:{//交易完成
                self.showHUD = NO;
                [self completeTransaction:transaction];
            } break;
            case SKPaymentTransactionStateFailed://交易失败
                self.showHUD = NO;
            { [self failedTransaction:transaction];
            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                self.showHUD = NO;
                [self restoreTransaction:transaction];
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                break;
            default:
                break;
        }
    }
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction{
    NSData *transactionReceiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *receipt = [transactionReceiptData base64EncodedStringWithOptions:0];
    NSDictionary *params = @{@"receipt-data":receipt?:@"",@"id":self.order_id?:@""};
    [[NSUserDefaults standardUserDefaults]setObject:params forKey:kIAPLOCALSTORE];
    self.showHUD  = YES;
    @weakify(self);
    [[ApiFactory pay_verifyIap:params]subscribeNext:^(id x) {
        self.showHUD  = NO;
        @strongify(self);
        if ([x[@"status"] isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kIAPLOCALSTORE];
            if (self.delegate && [self.delegate respondsToSelector:@selector(completeTransaction:)]) {
                [self.delegate completeTransaction:transaction];
            }
        }else if ([x[@"code"] isEqual:@105]){
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kIAPLOCALSTORE];
            if (self.delegate && [self.delegate respondsToSelector:@selector(restoreTransaction:)]) {
                [self.delegate restoreTransaction:transaction];
            }
        }
        else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(failedTransaction:)]) {
                [self.delegate failedTransaction:transaction];
            }
        }
    } error:^(NSError *error) {
        @strongify(self);
        self.showHUD  = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(failedTransaction:)]) {
            [self.delegate failedTransaction:transaction];
        }
    }];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}


- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(failedTransaction:)]) {
        [self.delegate failedTransaction:transaction];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@" 交易恢复处理");
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}


-(void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
}







@end
