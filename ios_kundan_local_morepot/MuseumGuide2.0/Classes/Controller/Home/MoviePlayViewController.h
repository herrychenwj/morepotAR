//
//  MoviePlayViewController.h
//  Mp3Player
//
//  Created by Mr.Huang on 2017/3/8.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviePlayViewController : UIViewController

+ (MoviePlayViewController *)moviePlayerWithVideoUrl:(NSString *)url;

/** 视频URL */
@property (nonatomic, strong) NSURL *videoURL;
@end
