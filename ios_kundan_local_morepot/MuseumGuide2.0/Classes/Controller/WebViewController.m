//
//  WebViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/23.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "WebViewController.h"
#import "MuBackButton.h"
#import "MBProgressHUD+Add.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKUIDelegate>
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *html;


@end

@implementation WebViewController
+ (WebViewController *)webControllerWithUrl:(NSString *)url{
    WebViewController *webVc = [[WebViewController alloc]init];
    webVc.url = url;
    return webVc;
}

+ (WebViewController *)webControllerWithHtml:(NSString *)htmlCode{
    WebViewController *webVc = [[WebViewController alloc]init];
    webVc.html = htmlCode;
    
    
    
    return webVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = ({
        WKPreferences *p = [[WKPreferences alloc]init];
        p.javaScriptEnabled = YES;
        p.javaScriptCanOpenWindowsAutomatically = YES;
        WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc]init];
        conf.preferences = p;
        [conf.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
        WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:conf];
        webView.UIDelegate = self;
        webView.scrollView.bouncesZoom = NO;
        webView.scrollView.bounces = NO;
        [self.view addSubview:webView];
        webView;
    });
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    if (self.url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [self.webView loadRequest:request];
    }else{
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"localApi" ofType:@"bundle"];
        NSString *basePath = [NSString stringWithFormat: @"%@/3dfile", bundlePath];
        NSURL *baseUrl = [NSURL fileURLWithPath: basePath isDirectory: YES];
        NSString *indexPath = [NSString stringWithFormat: @"%@/%@.html", basePath,self.html];
        NSString *indexContent = [NSString stringWithContentsOfFile:
                                  indexPath encoding: NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString: indexContent baseURL: baseUrl];
        
    }
    if (self.D3) {
        self.webView.backgroundColor = [UIColor clearColor];
        [self.webView setOpaque:NO];
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [backBtn setImage:[UIImage imageNamed:@"close_ar"] forState:UIControlStateNormal];
        [self.view addSubview:backBtn];
        [backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view).offset(-60);
            make.left.equalTo(self.view).offset(8);
            make.width.equalTo(@30);
            make.height.equalTo(@80);
        }];
        [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.label.sakura.text(@"pleasewait3D");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
    }else{
        [self setBackTitle:@""];
        if (self.newsMode) {
            self.backBtn.backImg.image = [UIImage imageNamed:@"menu_back_o"];
        }
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
}


@end
