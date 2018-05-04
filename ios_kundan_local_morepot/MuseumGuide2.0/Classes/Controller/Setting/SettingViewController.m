//
//  SettingViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingItemTableViewCell.h"
#import "RootViewController.h"
#import "UserHomeViewController.h"
#import "ShareViewController.h"
#import "SystemGuideViewController.h"
#import "LoginViewController.h"
#import "CurrentMuseum.h"
#import "FeedbackViewController.h"
#import "AppDelegate.h"
#import "NewsViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *settingItems;

@end
static NSString *const cellID = @"SettingItemTableViewCell";

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.settingItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSDictionary *dic = [self.settingItems objectAtIndex:indexPath.row];
    cell.itemTitleLB.text = [dic objectForKey:@"title"];
    cell.itemIcon.image = [UIImage imageNamed:[dic objectForKey:@"icon"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [Communtil playClickSound];
    switch (indexPath.row) {
        case 0:{
            NewsViewController *vc  = [[NewsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            UserHomeViewController *vc = [[UserHomeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            UMShareWebpageObject *obj = [UMShareWebpageObject shareObjectWithTitle:@"云观博" descr:@"苏州和云观博数字科技有限公司， 是全球首款基于AR技术的全博物馆领域智慧应用的开发者，依托强大的技术研发团队、深度资源整合能力以及开放性创意平台，致力于打造全新的博物馆文化知识传播生态圈。“云观博AR智慧博物馆导览”，基于计算机机器视觉技术，结合云计算、物联网和大数据应用；突破了传统博物馆藏品展陈的时空限制，真正实现“让文物活起来”！是移动“互联网+”时代下，改变博物馆观览方式的革命性产品。" thumImage:@"https://www.morview.com/img/logo.png"];
            obj.webpageUrl = @"https://www.morview.com/";
            ShareViewController *vc = [ShareViewController shareWithObject:obj];
            [self presentTransparentController:vc animated:YES];
        }
            break;
        case 3:{
            SystemGuideViewController *vc = [[SystemGuideViewController alloc]init];
            vc.type = SystemGuideType;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{
            FeedbackViewController *vc = [[FeedbackViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{
            SystemGuideViewController *vc = [[SystemGuideViewController alloc]init];
            vc.type = SystemAbout;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        default:
            break;
    }
}


#pragma mark initUI
- (void)initUI{
    self.view.backgroundColor = [UIColor blackColor];
    [self setBackTitle:@"菜单"];
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerClass:[SettingItemTableViewCell class] forCellReuseIdentifier:cellID];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.bounces = NO;
        tableView. delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = IPHONE_DEVICE?50:70;
        [self.view addSubview:tableView];
        tableView;
    });
    if (IPHONE_DEVICE) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(86, 0, 0, 0));
        }];
    }else{
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(86, kPADSETTING_LEFTMARGIN, 0, 0));
        }];
    }

}



#pragma mark lazy load
- (NSArray *)settingItems{
    if (!_settingItems) {
        _settingItems = @[@{@"title":@"动态",@"icon":@"menu_news"},@{@"title":@"用户中心",@"icon":@"menu_usercenter"},@{@"title":@"分享APP",@"icon":@"menu_share"},@{@"title":@"系统说明",@"icon":@"menu_setting"},@{@"title":@"用户反馈",@"icon":@"menu_fankui"},@{@"title":@"关于我们",@"icon":@"menu_aboutus"}];
    }
     return  _settingItems;
}




@end
