//
//  RewardViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "RewardViewController.h"
#import "Order.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <WXApiObject.h>
#import "AppDelegate+Conf.h"
#import "WXPaySign.h"
#import <AFNetworking/AFNetworking.h>
#import "XMLHelper.h"
#import <CommonCrypto/CommonCrypto.h>
#import "RewardMainView.h"
#import "MBProgressHUD+Add.h"

#define kALIPAYPRIVATEKEY  @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCYyTzjv3F5We96UBv/pQ/uuYyqFz+eqmsBcEX47U14yHLHXdB11YrYxHfHngXclRnfFcWkwaBEJn8D3Dt0a2p/87IlOjCG0PY6O6zKEUgdH+inys0YfNJvn4QjorfT6gI7IARw4gbG7c0UjYFInXkOMKJ/5A5VGnZg6GEdzro3fXNxVcGKMowPhjF0EouV8MNlwLW+IGnioD4wExZ7ux0/OIFSVWZyOmcFat5KhhOYrYNKbSHktkfCXNZe9npfgmH3QDoJ6jT1AvIkBz6EjrloCJPGlGmVmq3054LiBmj16TD5YfUxxF50CnbuCmga4jMLwWRm7hJjc8NcwnGMs645AgMBAAECggEAeQgRYCkr7wG7n50OUPmlIWuDbspz73D4y27xPzxc/q1rn1tF49KB5y3b5Rndctv6XqqUoutv1gzY2WoA/zyIZUvbd3odLu8h3wee3YPLKKc6WpFg32EiIqKuvrwL+6eIlOXMHtAupi+DIiDmpWt5ljAYyk8Su3/2/tWW+VHmWkWgOKOTBwLxjaSz7wnizlHVcHk5LMVleMTHjYoksN805zr6WviqEpj0bcd0Q/dDUkkqbg/kAmpJtDONQFvoK1GTxycMHCGBcQ2DX9NCjkXeZRaQJVhF9Y6pAX1s2kJyu1cuoAQqtwj1hM9o3xRf5W7MB7lNTQUiX/bIMfoIMTr2wQKBgQDYFF4Rv2L7977EXYnxEiLwf5EPZYr/8RObAsLJ3WIUO8DF+tK57I0dFpHVi9gGHoUd6/gBZFdbpCFh6yQm1Rypbh8PLoYe5SViXeJNCf4Nja0HRSFBwhJ0SE7WXkckhz9kgZNCR2LGg0bWcFw4EYxGRGzgRFv7C4tV8IAuz+xy1QKBgQC1A1yT1JCFiZ2kfpbf8WNpwgnPijyGkoblZjqwuTt6yk7BwyZrOBY550tEN1CzoD4l8Jooottmpu8sox1LmHjHYmWnQupIG/s0dtcUinDkcl34Bcb3jV7FrPWLH4g2VySDRoran85FXct4Bj6S2Hw95EdV2cbHBWptvBdeoYsX1QKBgQCs/zGJWAdx4Bo1sQYdof2jOx7yisPMwkCGHKHDaKF7vZNLbtOD06XvIgDETeA4lfrRx/iZdLKURkYL1WzuQjVeWTI4v3DWD3Ps22mxcEycoU9kwK4tramEu9eSvYyL7FSOrUcvC2RDtxrh2LeclEAQifv5WgGibs2xkomt8P5HuQKBgArJ0oC1EJAE7bJaIR/jwSsSd4c5E/ZpUUTm3OSfhZ4B5MPDn8yQITL+SAwex96M1GdqeaWmXzE1Ddg5OIvC4J/xi2F2qYP2tvgfhR4iSiwzbMpVfdBPSrC5aEEMdg/XDcQNNkVldOPJfVD//ka+RFlj+6RwQFqoRfmYVkQ7mJCpAoGAM8EOAcPgbnJajft7/T5QtQpRU3KRefEZ8LY8NP97NUUfIF3R8rXHLualybYnlVTMc7qFfvuebeefnx6u50cIx7D4viWniE6r2QMNro9uypAzquWK7quW2RKyF1SaotQWZNg5NjaTLmIOJxaM4cWwyr/0w8SbQlakYUAdUqzjbts="

@interface RewardViewController ()
@property (nonatomic,strong)RewardMainView *rewardView;
@end
//微信支付统一下单URL
static NSString *const   wxurl = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
static NSString *pay;
@implementation RewardViewController

- (void)bindViewModel{
    @weakify(self);
    [[self.rewardView.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [TalkingData trackEvent:@"关闭打赏"];
        [self anmiationDismiss:^(BOOL finished){
            @strongify(self);
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }];
    [[self.rewardView.aliBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        pay = @"支付宝打赏";
        [self alipayWithPrice:(self.rewardView.selectIndex == 0)?2.0:(self.rewardView.selectIndex == 1)?5.0:10.0];
    }];
    [[self.rewardView.wxBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        pay = @"微信打赏";
        [self wxPayWithPrice:(self.rewardView.selectIndex == 0)?2.0:(self.rewardView.selectIndex == 1)?5.0:10.0];
        }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kREWARDSUCCESS object:nil]subscribeNext:^(id x) {
        @strongify(self);
        [self anmiationDismiss:^(BOOL finished){
            @strongify(self);
            NSString *str = [NSString stringWithFormat:@"%i",(self.rewardView.selectIndex == 0)?2:(self.rewardView.selectIndex == 1)?5:10];
            NSDate *now = [NSDate new];
            NSDateFormatter *fm = [[NSDateFormatter alloc]init];
            [fm setDateFormat:@"YYY-MM-dd HH:mm"];
            NSString *time = [fm stringFromDate:now];
            [TalkingData trackEvent:pay label:self.trackName parameters:@{time:str}];
            [self dismissViewControllerAnimated:NO completion:self.rewardSuccess];
        }];
    }];
    
}
- (void)anmiationDismiss:(void(^)(BOOL))complete{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = CGPointMake(IPHONE_DEVICE?22:70, kSCREEN_HEIGHT/2 +65);
        CGRect viewFrme = CGRectMake(0, 0, IPHONE_DEVICE?31:40,  IPHONE_DEVICE?56:72);
        self.rewardView.bounds = viewFrme;
        self.rewardView.center = center;
    }completion:complete];
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect viewFrme = CGRectMake(0, 0, kSCREEN_WIDTH - (kINFOCONTROLLERLEFT_MARGIN+2)*2, 355);
        self.rewardView.bounds = viewFrme;
        self.rewardView.center = self.view.center;
    }];
}

- (void)initUI{
    self.view.backgroundColor = [UIColor blackColor];
    _rewardView = ({
        CGPoint center = CGPointMake(IPHONE_DEVICE?22:70, kSCREEN_HEIGHT/2 +65);
        CGRect viewFrme = CGRectMake(0, 0, IPHONE_DEVICE?31:40,  IPHONE_DEVICE?56:72);
        RewardMainView *view = [[RewardMainView alloc]initWithFrame:viewFrme];
        view.center = center;
        view.backgroundColor = HexRGB(0xF2F2F2);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 3.f;
        view.titleLabel.sakura.text(@"rewardtitle");
        view.subLabel.sakura.text(@"rewardsub");
        view.rewardLabel.sakura.text(@"choosereward");
        view.chooseLabel.sakura.text(@"rewardsum");
        [view.leftBtn setTitle:[TXSakuraManager tx_stringWithPath:@"two"] forState:UIControlStateNormal];
        [view.leftBtn setTitle:[TXSakuraManager tx_stringWithPath:@"two"]  forState:UIControlStateHighlighted];
        [view.midBtn setTitle:[TXSakuraManager tx_stringWithPath:@"five"]  forState:UIControlStateNormal];
        [view.midBtn setTitle:[TXSakuraManager tx_stringWithPath:@"five"]  forState:UIControlStateHighlighted];
        [view.rightBtn setTitle:[TXSakuraManager tx_stringWithPath:@"ten"]  forState:UIControlStateNormal];
        [view.rightBtn setTitle:[TXSakuraManager tx_stringWithPath:@"ten"]  forState:UIControlStateHighlighted];
        [self.view addSubview:view];
        view;
    });
    if (IPHONE_DEVICE) {
        [self.rewardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kINFOCONTROLLERLEFT_MARGIN+2);
            make.right.equalTo(self.view).offset(-(kINFOCONTROLLERLEFT_MARGIN+2));
            make.center.equalTo(self.view);
            make.height.equalTo(@355);
        }];
    }else{
        [self.rewardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kPADSETTING_LEFTMARGIN+2);
            make.right.equalTo(self.view).offset(-(kINFOCONTROLLERLEFT_MARGIN+2));
            make.center.equalTo(self.view);
            make.height.equalTo(@355);
        }];
    }

}

//微信支付(以元为单位)
- (void)wxPayWithPrice:(float)price{
    NSString* orderName = @"打赏给云观博";
    NSString* orderPrice = [NSString stringWithFormat:@"%i",(int)(price*100)];
    NSString* orderDevice = @"WEB";
    NSString* orderType = @"APP";
    NSString* orderIP = [WXPaySign deviceIPAdress];
    srand( (unsigned)time(0) );
    NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
    NSString *orderNO   = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
    [packageParams setObject: wxKey  forKey:@"appid"];
    [packageParams setObject: wxMch_id  forKey:@"mch_id"];
    [packageParams setObject: orderDevice  forKey:@"device_info"];
    [packageParams setObject: noncestr     forKey:@"nonce_str"];
    [packageParams setObject: orderType    forKey:@"trade_type"];
    [packageParams setObject: orderName    forKey:@"body"];
    [packageParams setObject: @"http://test.morview.com/payment/wechatpay/notify"  forKey:@"notify_url"];
    [packageParams setObject: orderNO      forKey:@"out_trade_no"];
    [packageParams setObject: orderIP      forKey:@"spbill_create_ip"];
    [packageParams setObject: orderPrice   forKey:@"total_fee"];
    NSString * prePayID = [self getPrePayId:packageParams];
    if (!prePayID) {
        //获取订单出错  支付失败
        [MBProgressHUD showMessag:[TXSakuraManager tx_stringWithPath:@"pay_fail"] toView:self.view];
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    NSString    *package, *time_stamp, *nonce_str;
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    nonce_str = [self md5:time_stamp];
    package   = @"Sign=WXPay";
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: wxKey  forKey:@"appid"];
    [signParams setObject: wxMch_id  forKey:@"partnerid"];
    [signParams setObject: nonce_str    forKey:@"noncestr"];
    [signParams setObject: package      forKey:@"package"];
    [signParams setObject: time_stamp   forKey:@"timestamp"];
    [signParams setObject: prePayID     forKey:@"prepayid"];
    PayReq* req = [[PayReq alloc] init];
    req.partnerId = wxMch_id;
    req.prepayId = prePayID;
    req.nonceStr = nonce_str;
    req.timeStamp = time_stamp.intValue;
    req.package = package;
    req.sign = [self createMd5Sign:signParams];
    if ([WXApi sendReq:req]) { //调起支付成功
        
    }else{
        [MBProgressHUD showMessag:[TXSakuraManager tx_stringWithPath:@"pay_fail"] toView:self.view];
    }

}

#pragma mark ---  创建package签名

- (NSData *)httpSend:(NSString *)url method:(NSString *)method data:(NSString *)data{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [request setHTTPMethod:method];
    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    return response;
}


- (NSString*)createMd5Sign:(NSMutableDictionary*)dict{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortedArray) {
        if ( ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            ){
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    [contentString appendFormat:@"key=%@", wxApi_key];
    NSLog(@"%@",contentString);
    NSString *md5Sign =[self md5:contentString];
    return md5Sign;
}


- (NSString *)genPackage:(NSMutableDictionary*)packageParams{
    NSString *sign;
    NSMutableString *reqPars=[NSMutableString string];
    sign = [self createMd5Sign:packageParams];
    NSArray *keys = [packageParams allKeys];
    [reqPars appendString:@"<xml>\n"];
    for (NSString *categoryId in keys) {
        [reqPars appendFormat:@"<%@>%@</%@>\n", categoryId, [packageParams objectForKey:categoryId],categoryId];
    }
    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", sign];
    
    return [NSString stringWithString:reqPars];
}

- (NSString *)generateTradeNO{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++){
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

-(NSString *)getPrePayId:(NSMutableDictionary *)pakeParams{
    NSString *prepayid = nil;
    NSString *send = [self genPackage:pakeParams];
    NSData *res = [self httpSend:wxurl method:@"POST" data:send];
    XMLHelper *xml  = [[XMLHelper alloc] init];
    [xml startParse:res];
    NSMutableDictionary *resParams = [xml getDict];
    NSString *return_code   = [resParams objectForKey:@"return_code"];
    NSString *result_code   = [resParams objectForKey:@"result_code"];
    if ([return_code isEqualToString:@"SUCCESS"]) {
        NSString *sign      = [self createMd5Sign:resParams ];
        NSString *send_sign =[resParams objectForKey:@"sign"];
        if ([sign isEqualToString:send_sign]) {
            if ([result_code isEqualToString:@"SUCCESS"]) {
                prepayid = [resParams objectForKey:@"prepay_id"];
            }
        }
    }
    return prepayid;
}

//支付宝支付(以元为单位)
- (void)alipayWithPrice:(float)price{
    NSString *rsa2PrivateKey = kALIPAYPRIVATEKEY;
    NSString *rsaPrivateKey = @"";
    Order* order = [Order new];
    order.app_id = alipay_id;
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    // NOTE: 支付版本
    order.version = @"1.0";
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"打赏给云观博";
    order.biz_content.subject = @"打赏给云观博";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", price]; //商品价格
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    if (signedString != nil) {
        NSString *appScheme = @"museum2.0";
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *result = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]];
            if ([result isEqualToString:@"9000"]) {
                NSString *str = [NSString stringWithFormat:@"%i",(self.rewardView.selectIndex == 0)?2:(self.rewardView.selectIndex == 1)?5:10];
                NSDate *now = [NSDate new];
                NSDateFormatter *fm = [[NSDateFormatter alloc]init];
                [fm setDateFormat:@"YYY-MM-dd HH:mm"];
                NSString *time = [fm stringFromDate:now];
                [TalkingData trackEvent:pay label:self.trackName parameters:@{time:str}];
                [self dismissViewControllerAnimated:NO completion:self.rewardSuccess];
            }
        }];
    }else{
        [MBProgressHUD showMessag:[TXSakuraManager tx_stringWithPath:@"pay_fail"] toView:self.view];
    }
}


- (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    return output;
}
@end
