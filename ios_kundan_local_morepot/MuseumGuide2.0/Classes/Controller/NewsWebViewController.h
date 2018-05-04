//
//  NewsWebViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/10/25.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewController.h"

@interface NewsWebViewController : BaseViewController
@property (nonatomic,copy)NSString *url;
@property (nonatomic,strong)UIWebView *webView;
@end
