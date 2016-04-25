//
//  MyFolloweeViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/23.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "MyFolloweeViewController.h"
#import "FolloweeTableViewCell.h"
#import "CCUser.h"
#import "SVProgressHud.h"
#import "CCFile.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#define QueryLimit 20

static NSString * CellRusedIdentifier = @"FolloweeTableViewCell";

@interface MyFolloweeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray * factoryList;
@end

@implementation MyFolloweeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any t setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets  = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView addHeaderWithTarget:self action:@selector(tableViewPullDown)];
    [self.tableView addFooterWithTarget:self action:@selector(tableViewPullUp)];
    [self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableViewPullDown
{
    [CCUser getFollowedFactoryListWithLimit:QueryLimit skip:0 block:^(NSArray *followList, NSError *error) {
        [self.tableView headerEndRefreshing];
        if (error) {
            
        } else {
            self.factoryList = [NSMutableArray arrayWithArray:followList];
            [self.tableView reloadData];
        }
    }];
}

- (void)tableViewPullUp
{
    if (self.factoryList.count < QueryLimit) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [CCUser getFollowedFactoryListWithLimit:QueryLimit skip:0 block:^(NSArray *followList, NSError *error) {
        [self.tableView headerEndRefreshing];
        if (error) {
            
        } else {
            [self.factoryList addObjectsFromArray:followList];
            [self.tableView reloadData];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.factoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FolloweeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellRusedIdentifier];
    CCUser * factory = [self.factoryList objectAtIndex:indexPath.row];
    [cell.portraitImageView sd_setImageWithURL:[CCFile ccURLWithString:factory.headImgUrl]];
    cell.nameLabel.text = factory.factoryName;
    cell.phoneNumLabel.text = factory.mobile;
    cell.totalNumLabel.text = [NSNumber numberWithInteger:factory.totalNum].stringValue;
    cell.lastestNumLabel.text = [NSNumber numberWithInteger:factory.newNum].stringValue;
    return cell;
}

@end
