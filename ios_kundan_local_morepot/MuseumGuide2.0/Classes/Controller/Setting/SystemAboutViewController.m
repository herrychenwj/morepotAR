//
//  SystemAboutViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/8/10.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "SystemAboutViewController.h"

@interface SystemAboutViewController ()<UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataAry;
@end

@implementation SystemAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackTitle:[TXSakuraManager tx_stringWithPath:@"system_instructions"]];
    self.view.backgroundColor = HexRGB(0x202126);
    UILabel *versionLB = [[UILabel alloc]initWithFrame:CGRectZero];
    versionLB.font = [UIFont systemFontOfSize:15];
    versionLB.textAlignment = NSTextAlignmentCenter;
    versionLB.textColor = [UIColor whiteColor];
    versionLB.text = [NSString stringWithFormat:@"V %@",[Communtil app_versionNumber]];
    [self.view addSubview:versionLB];
    [versionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(IPHONE_DEVICE?self.view:self.tableView);
        make.bottom.equalTo(self.view).offset(-20);
    }];
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = (kSCREEN_WIDTH - kBACK_SPACE - 50)*1.77;
        tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        IPHONE_DEVICE?make.left.equalTo(self.view).offset(kBACK_SPACE):make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(96);
        make.right.bottom.equalTo(self.view).offset(-50);
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [cell addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell);
    }];
    imgView.image = [UIImage imageNamed:self.dataAry[indexPath.row]];
    return cell;
}

- (NSArray *)dataAry{
    if (!_dataAry ) {
        _dataAry = @[@"1_1.jpg",@"1_2.jpg",@"1_3.jpg",@"1_4.jpg",@"2.jpg",@"3.jpg",@"4_1.jpg",@"4_2.jpg",@"5_1.jpg",@"5_2.jpg",@"5_3.jpg",@"5_4.jpg"];
    }
    return _dataAry;
}




@end
