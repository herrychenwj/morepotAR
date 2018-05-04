//
//  MeseumTableViewCell.h
//  Museum
//
//  Created by MR.Huang on 2017/2/16.
//  Copyright © 2017年 94kz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MeseumTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic,strong)UILabel *nameLB;
@property (nonatomic,strong)UILabel *addressLB;
@property (nonatomic,strong)UILabel *disLB;
    
@property (nonatomic,strong)UIImageView *anmiationView;

@property (nonatomic,assign)BOOL anmiation;
- (void)startAnmiation;



@end
