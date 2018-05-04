//
//  WebViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/23.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController : BaseViewController

+ (WebViewController *)webControllerWithUrl:(NSString *)url;
+ (WebViewController *)webControllerWithHtml:(NSString *)htmlCode;

@property (nonatomic,assign)BOOL D3;
@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic,assign)BOOL newsMode;


@end
