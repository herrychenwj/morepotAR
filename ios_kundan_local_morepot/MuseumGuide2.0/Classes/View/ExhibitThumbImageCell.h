//
//  ExhibitThumbImageCell.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/6/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExhibitThumbImageCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *thumbImgView;
@property (nonatomic,strong)UIImageView *playIcon;


- (void)setMovieMode:(BOOL)movie;



@end
