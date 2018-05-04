//
//  UserCenterViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/7/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterListTableViewCell.h"
#import "UserCenterAvatarView.h"
#import "UserCenterSettingViewController.h"
#import "FeedbackViewController.h"
#import "LoginViewController.h"
#import "EnshrineViewController.h"
#import "ShareViewController.h"
#import "UserInfoModel.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "BindPhoneViewController.h"
#import "UserInfoViewController.h"
#import "UserInfoViewModel.h"
#import "FootprintViewController.h"

@interface UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UserCenterAvatarView *avatarImgView;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)UserInfoViewModel *viewModel;

@end
static NSString *const cellID = @"UserCenterListTableViewCell";

@implementation UserCenterViewController



- (void)bindViewModel{
    @weakify(self);
    [[self.avatarImgView.blankControl rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (![Communtil isLogin]) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [loginVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            UserInfoViewController *userVC = [[UserInfoViewController alloc]init];
            [userVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:userVC animated:YES];
        }
    }];
}

- (void)initUI{
    self.view.backgroundColor = HexRGB(0x202126);
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerClass:[UserCenterListTableViewCell class] forCellReuseIdentifier:cellID];
        tableView.rowHeight = 50;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    _avatarImgView = ({
        UserCenterAvatarView *avatar = [[UserCenterAvatarView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
        avatar;
    });
    self.tableView.tableHeaderView = self.avatarImgView;
    if (IPHONE_DEVICE) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }else{
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 100, 0, 100));
        }];
    }

}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Communtil isLogin]) { //已经登录
        [self.avatarImgView.actionBtn setTitle:[UserInfoModel shareInfo].nickname forState:UIControlStateNormal];
        [self.avatarImgView.avatarImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfoModel shareInfo].avatarurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nologin"]];
    }else{
        [self.avatarImgView.actionBtn setTitle:[TXSakuraManager tx_stringWithPath:@"login_home"] forState:UIControlStateNormal];
        [self.avatarImgView.avatarImgView setImage:[UIImage imageNamed:@"nologin"] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? ([Communtil isLogin]?[self.dataAry[0] count]:[self.dataAry[0] count]-1):[self.dataAry[1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCenterListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.cellType = ListCellTypeArrow;
    NSDictionary *dic = self.dataAry[indexPath.section][indexPath.row];
    cell.iconView.image = [UIImage imageNamed:dic[@"icon"]];
    cell.titleLabel.sakura.text(dic[@"title"]);
    if (indexPath.section == 0 && indexPath.row == 3) {
        if ([UserInfoModel shareInfo].phone.length > 0) {
            cell.numLabel.text =[UserInfoModel shareInfo].phone;
        }else{
            cell.numLabel.sakura.text(@"no_bind");
        }
        cell.cellType = ListCellTypeLabel;
        cell.hidden = ![Communtil isLogin];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [Communtil playClickSound];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                if ([Communtil isLogin]) {
                    EnshrineViewController *vc = [EnshrineViewController Controller:ListControllerType_Collection];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    LoginViewController *loginVC = [[LoginViewController alloc]init];
                    [loginVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:loginVC animated:YES];
                }
                break;
            case 1:
                if ([Communtil isLogin]) {
                    FootprintViewController *vc = [[FootprintViewController alloc]init];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    LoginViewController *loginVC = [[LoginViewController alloc]init];
                    [loginVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:loginVC animated:YES];
                }
                break;
            case 2:
                if ([Communtil isLogin]) {
                    EnshrineViewController *vc = [EnshrineViewController Controller:ListControllerType_Comment];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    LoginViewController *loginVC = [[LoginViewController alloc]init];
                    [loginVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:loginVC animated:YES];
                }
                break;
            case 3:{
                BindPhoneViewController *vc = [BindPhoneViewController VerificationNextAction:^(NSString *phoneNum) {
                    [UserInfoModel shareInfo].phone = phoneNum;
                    [self.tableView reloadData];
                } type:[UserInfoModel shareInfo].bindType];
                [self presentTransparentController:vc];
            }
                break;
            default:
                break;
        }


    }else{
        switch (indexPath.row) {
                case 0:{
                    UMShareWebpageObject *obj = [UMShareWebpageObject shareObjectWithTitle:@"云观博" descr:@"苏州和云观博数字科技有限公司， 是全球首款基于AR技术的全博物馆领域智慧应用的开发者，依托强大的技术研发团队、深度资源整合能力以及开放性创意平台，致力于打造全新的博物馆文化知识传播生态圈。“云观博AR智慧博物馆导览”，基于计算机机器视觉技术，结合云计算、物联网和大数据应用；突破了传统博物馆藏品展陈的时空限制，真正实现“让文物活起来”！是移动“互联网+”时代下，改变博物馆观览方式的革命性产品。" thumImage:@"https://www.morview.com/img/logo.png"];
                    obj.webpageUrl = @"https://www.morview.com/";
                    ShareViewController *vc = [ShareViewController shareWithObject:obj];
                    [self presentTransparentController:vc animated:YES];
                }
                break;
                case 1:{

                    UserCenterSettingViewController *vc = [[UserCenterSettingViewController alloc]init];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                break;
                case 2:{
                    FeedbackViewController *vc = [[FeedbackViewController alloc]init];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                break;
            default:
                break;
        }
    }
}

- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [@[@[@{@"icon":@"user_store",@"title":@"mycollect"},@{@"icon":@"footprint",@"title":@"footprint"},@{@"icon":@"user_cmt",@"title":@"mycomment"},@{@"icon":@"user_bindphone",@"title":@"bindphones"}],@[@{@"icon":@"user_share",@"title":@"shareAPP"},@{@"icon":@"user_setting",@"title":@"system_setting"},@{@"icon":@"user_feedback",@"title":@"feedback"}]] mutableCopy];
    }
    return _dataAry;
}




@end
