
//
//  ExhibitInfoModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ExhibitInfoModel.h"
#import "Communtil.h"
#import "YYText.h"

@implementation ExhibitInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"mDescription":@"description"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"audio":@"AudioModel",@"comments":@"ExhibitCommentModel"};
}

- (void)setMDescription:(NSString *)mDescription{
    _mDescription = mDescription;
    _mDescription = [_mDescription stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
}

- (BOOL)isDescOpen{
    return YES;
}


- (void)setAudio:(NSArray<AudioModel *> *)audio{
    _audio = audio;
    for (AudioModel *audio in _audio) {
        if ([audio.audiotype isEqualToString:@"mandarin"]) {
            self.mandarin = audio.filename;
        }else if ([audio.audiotype isEqualToString:@"dialect"]){
            self.dialect = audio.filename;
        }
    }
}


- (void)setComments:(NSMutableArray<ExhibitCommentModel *> *)comments{
    _comments = comments;
    self.page_index  = (_comments.count > 0)?@1:@0;
}

- (void)setImages:(NSArray *)images{
    _images = images;
    if (_images.count < 2) {
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:_images];
        [tmp addObjectsFromArray:( _images.count == 0)?@[@"",@""]:@[@""]];
        _images = [tmp copy];
    }
}




- (NSAttributedString *)attrDescription{
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:13];
    //添加文本
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:self.mDescription?:@"" attributes:nil]];
    text.yy_font = font ;
    text.yy_color = [UIColor whiteColor];
    text.yy_lineSpacing = kYYLINE_SPACE;
    return [text copy];
}

- (CGFloat)cellHeight{
    CGFloat maxWidth = IPHONE_DEVICE?(kSCREEN_WIDTH - 64 - 28):(kSCREEN_WIDTH*0.33-28);
    CGFloat contentH = [Communtil yy_cellHeight:self.attrDescription openSwitch:self.isDescOpen maxWidth:maxWidth maxCellHeight:125];
    return self.isDescOpen?contentH+20:contentH;
}

@end
@implementation AudioModel

@end

@implementation VideoModel

@end


