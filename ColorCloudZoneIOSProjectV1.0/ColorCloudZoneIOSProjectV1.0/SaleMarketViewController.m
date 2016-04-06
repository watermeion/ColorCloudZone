//
//  SaleMarketViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/31.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "SaleMarketViewController.h"
#import "SVProgressHud.h"

@interface SaleMarketViewController ()
@property (nonatomic, strong) NSArray * markets;

@end

@implementation SaleMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SVProgressHUD showWithStatus:@"正在获取列表"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [CCUser getSaleMarketListWithBlock:^(NSArray *saleMarketList, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        } else {
            _markets = saleMarketList;
            [self.tableView reloadData];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _markets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SaleMarketCell"];
    CCSaleMarket * market = [_markets objectAtIndex:indexPath.row];
    cell.textLabel.text = market.saleMarketName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCSaleMarket * market = [_markets objectAtIndex:indexPath.row];
    self.parentUser.saleMarketId = market.saleMarketId;
    self.parentUser.saleMarketName = market.saleMarketName;
    self.parentUser.saleMarketAddress = market.saleMarketAddress;
    [self.navigationController popViewControllerAnimated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
