//
//  LanguageViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/10/23.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "LanguageViewController.h"
#import "LanguageTableViewCell.h"

@interface LanguageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

static NSString *const cellID = @"LanguageTableViewCell";
@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    [self setBackTitle:[TXSakuraManager tx_stringWithPath:@"language"]];
    self.backBtn.titleLB.sakura.text(@"language");
    self.view.backgroundColor = HexRGB(0x202126);
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView;
    });
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(IPHONE_DEVICE?85:120, IPHONE_DEVICE?0:kPADSETTING_LEFTMARGIN, 0, IPHONE_DEVICE?0:90));
    }];
}

#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LanguageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LanguageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    NSString *language = [[NSUserDefaults standardUserDefaults]objectForKey:kLOCALIZABLE];
    if ([language isEqualToString:@"cn"] && indexPath.row == 0 ) {
        cell.pointView.hidden = NO;
    }else if ([language isEqualToString:@"en"] && indexPath.row == 1) {
        cell.pointView.hidden = NO;
    }else{
        cell.pointView.hidden = YES;
    }
    cell.textLabel.text = indexPath.row == 0 ? @"中文":@"English";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *sel = indexPath.row == 0?@"cn":@"en";
    NSString *localizable = [[NSUserDefaults standardUserDefaults]objectForKey:kLOCALIZABLE];
    if (![sel isEqualToString:localizable]) {
        [[NSUserDefaults standardUserDefaults]setObject:sel forKey:kLOCALIZABLE];
        [TalkingData trackEvent:(indexPath.row == 0)?@"切换中文":@"切换英文"];
        [TXSakuraManager shiftSakuraWithName:indexPath.row == 0?@"Localizable_cn":@"Localizable_en" type:TXSakuraTypeMainBundle];
        [self.tableView reloadData];
    }

}




@end
