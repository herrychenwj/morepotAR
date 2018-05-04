//
//  UserHomeViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UserHomeViewController.h"
#import "UserInfoViewController.h"
#import "UserHomeTableViewCell.h"
#import "UserHomeSettingTableViewCell.h"
#import "EnshrineViewController.h"
#import "LoginViewController.h"
#import <SDWebImage/SDImageCache.h>
#import "FileUtil.h"
#import "CurrentMuseum.h"
#import "UserSettingViewModel.h"
#import "UserInfoModel.h"
#import "BindPhoneViewController.h"

@interface UserHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UserSettingViewModel *viewModel;


@end

static NSString *const cellID = @"UserInfoTableViewCell";
static NSString *const settingCellID = @"UserInfoSettingTableViewCell";
@implementation UserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self bindViewModel];
}

#pragma mark UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1:3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UserHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.nameLB.text = [UserInfoModel shareInfo].nickname;
        cell.stateLB.text = [UserInfoModel shareInfo].personaltitle;
        [cell.avatarImg sd_setImageWithURL:[NSURL URLWithString:[UserInfoModel shareInfo].avatarurl] placeholderImage:[UIImage imageNamed:@"userpicture"]];
        cell.hidden = ![Communtil isLogin];
        return cell;
    }else{
        UserHomeSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellID forIndexPath:indexPath];
        if (indexPath.section == 1 && indexPath.row == 0) { //我的收藏
            cell.cellType = UserInfoCellTypeArrow;
            cell.titleLB.text = @"我的收藏";
        }else if (indexPath.section == 1 && indexPath.row ==1){ //我的评论
            cell.cellType = UserInfoCellTypeArrow;
            cell.titleLB.text = @"我的评论";
        }else if (indexPath.section == 1 && indexPath.row == 2){ //绑定手机号
            cell.cellType = UserInfoCellTypeArrow;
            cell.titleLB.text = @"绑定手机号";
            cell.subLB.text = [UserInfoModel shareInfo].phone;
            cell.hidden = ![Communtil isLogin];
        }else if (indexPath.section ==2 && indexPath.row == 0){ //系统声音
            cell.cellType = UserInfoCellTypePoint;
            BOOL sound = [[[NSUserDefaults standardUserDefaults]objectForKey:kUSERSETTING_SOUND] boolValue];
            [cell.tagBtn setImage:[UIImage imageNamed:sound?@"sound_on":@"sound_off"] forState:UIControlStateNormal];
            cell.titleLB.text = @"系统声音";
        }else if (indexPath.section == 2 && indexPath.row ==1){//清除缓存
            [TalkingData trackEvent:[CurrentMuseum museumName]?:@"云观博" label:@"清除缓存"];
            cell.titleLB.text = @"清除缓存";
        }else{ //退出登录
            cell.titleLB.text = [Communtil isLogin]?@"退出登录":@"立即登录";
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    [Communtil playClickSound];
    if (indexPath.section == 0) { //个人资料
        UserInfoViewController *vc = [UserInfoViewController controllerWithUserInfo:[UserInfoModel shareInfo]];
        vc.modification = ^(){
            @strongify(self);
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){ //我的收藏
        EnshrineViewController *vc = [EnshrineViewController Controller:ListControllerType_Collection];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1){ //我的评论 未登录跳转到登录页面
        if ([Communtil isLogin]) {
            EnshrineViewController *vc = [EnshrineViewController Controller:ListControllerType_Comment];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            LoginViewController *vc = [LoginViewController loginControllerWithLoginSuccess:^{
                @strongify(self);
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1 && indexPath.row == 2){ //绑定手机号
        BindPhoneViewController *vc = [BindPhoneViewController VerificationNextAction:^(NSString *phoneNum) {
            [UserInfoModel shareInfo].phone = phoneNum;
        } type:[UserInfoModel shareInfo].bindType];
        [self presentTransparentController:vc];
    }else if (indexPath.section == 2 && indexPath.row == 0){ //系统声音开关
        BOOL sound = [[[NSUserDefaults standardUserDefaults]objectForKey:kUSERSETTING_SOUND] boolValue];
        [[NSUserDefaults standardUserDefaults]setObject:@(!sound) forKey:kUSERSETTING_SOUND];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else if (indexPath.section == 2 && indexPath.row == 1){ //清除缓存
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"此操作会导致无法使用AR识别，确定要清除吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
             [self.viewModel.cleanCacheCmd execute:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancelAction];
        [alertVC addAction:doneAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{ //退出登录
        if ([Communtil isLogin]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kACCESS_TOKEN];
            [UserInfoModel cleanInfo];
            self.errorMsg = @"退出成功";
            [self.tableView reloadData];
        }else{
            LoginViewController *vc = [LoginViewController loginControllerWithLoginSuccess:^{
                @strongify(self);
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  [Communtil isLogin]?(IPHONE_DEVICE?60:86):0;
    }else if (indexPath.section == 1 && indexPath.row == 2){
        return [Communtil isLogin]?(IPHONE_DEVICE?50:76):0;
    }else{
        return (IPHONE_DEVICE?50:76);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return [Communtil isLogin]?30:0;
    }else{
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

#pragma mark BindViewModel

- (void)bindViewModel{
    self.viewModel = [[UserSettingViewModel alloc]init];
    [self setBaseViewModel:self.viewModel];
    @weakify(self);
    [self.viewModel.cleanCacheCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
       self.errorMsg = @"清理成功";
    }];
}


#pragma mark initUI
- (void)initUI{
    [self setBackTitle:@"返回"];
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        [tableView registerClass:[UserHomeTableViewCell class] forCellReuseIdentifier:cellID];
        [tableView registerClass:[UserHomeSettingTableViewCell class] forCellReuseIdentifier:settingCellID];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(IPHONE_DEVICE?86:120, IPHONE_DEVICE?0:kPADSETTING_LEFTMARGIN, 0, IPHONE_DEVICE?0:90));
    }];
}






@end
