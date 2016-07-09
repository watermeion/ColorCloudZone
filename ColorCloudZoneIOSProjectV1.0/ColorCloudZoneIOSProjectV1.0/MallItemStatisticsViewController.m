//
//  MallItemStatisticsViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/6/23.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "MallItemStatisticsViewController.h"
#import "CCFile.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHud.h"
#import "MallItemPropCell.h"

@interface MallItemStatisticsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray * skuInfos;
@end

@implementation MallItemStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.avatar sd_setImageWithURL:[CCFile ccURLWithString:self.parentItem.cover]];
    self.titleLabel.text = self.parentItem.name;
    self.SNLabel.text = [@"货号: " stringByAppendingString:self.parentItem.SN?self.parentItem.SN:@""];
    [SVProgressHUD showWithStatus:@"正在获取信息" maskType:SVProgressHUDMaskTypeBlack];
    [CCItem getMallItemStatistics:self.parentItem withBlock:^(NSInteger totalCount, NSArray *skuInfos, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        } else {
            self.sourceLabel.text = [@"来源: " stringByAppendingString:self.parentItem.factoryName?self.parentItem.factoryName:@""];
            self.totalCountLabel.text = [@"总计: " stringByAppendingString:[[NSNumber numberWithInteger:totalCount] stringValue]];
            self.skuInfos = skuInfos;
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
    return self.skuInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MallItemPropCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MallItemPropCell"];
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    CCItemStatisticsProp * prop = [self.skuInfos objectAtIndex:indexPath.row];
    cell.sizeLabel.text = prop.name2;
    cell.colorLabel.text = prop.name1;
    cell.countLabel.text = [[NSNumber numberWithInteger:prop.count] stringValue];
    return cell;
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
