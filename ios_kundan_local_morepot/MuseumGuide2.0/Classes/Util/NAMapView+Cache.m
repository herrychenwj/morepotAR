//
//  NAMapView+Cache.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/15.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "NAMapView+Cache.h"
#import "DownloadFactory.h"


#import "SVGKImage.h"

@implementation NAMapView (Cache)

- (void)displaySVGMapWithURL:(NSString *)url museum_id:(NSString *)museum_id{
//    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"localApi" ofType:@"bundle"];
//    NSString *x = [NSString stringWithFormat:@"%@/%@",bundlePath,url];
    NSData *data = [NSData dataWithContentsOfFile:url];
    if (data) {
        SVGKImage *svgImg = [SVGKImage imageWithData:data];
        [self displaySVGMap:svgImg];
    }
//    [[DownloadFactory cacheSVGWithUrl:url museum_id:museum_id]subscribeNext:^(id x) {
//        NSData *data = [NSData dataWithContentsOfFile:x];
//        if (data) {
//            SVGKImage *svgImg = [SVGKImage imageWithData:data];
//            [self displaySVGMap:svgImg];
//        }
//    }];
}
@end
