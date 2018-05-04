//
//  UIButton+SD.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UIButton+SD.h"
#import <objc/runtime.h>
#import <SDWebImage/UIButton+WebCache.h>
static char urlKey;

@implementation UIButton (SD)

- (void)setSd_url:(NSString *)sd_url{
    [self willChangeValueForKey:@"urlKey"];
    objc_setAssociatedObject(self, &urlKey,
                             sd_url,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"urlKey"];
    [self sd_setImageWithURL:[NSURL URLWithString:sd_url] forState:UIControlStateNormal placeholderImage:kPLACEHOLDERIMAGE];
}

- (NSString *)sd_url{
    return objc_getAssociatedObject(self, &urlKey);
}


@end
