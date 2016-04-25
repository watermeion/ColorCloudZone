//
//  MemberProfileViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/4/24.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "MemberProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "CCFile.h"
#import "CCItem.h"
#import "ShopListTableViewCell.h"
#import "MJRefresh.h"

#define QueryLimit 30

@interface MemberProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray * itemList;
@end

@implementation MemberProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameLabel.text = self.parentMember.username;
    self.phoneNumberLabel.text = self.parentMember.mobile;
    self.addressLabel.text = self.parentMember.address;
    [self.avatar sd_setImageWithURL:[CCFile ccURLWithString:self.parentMember.headImgUrl]];
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2.0;
    self.avatar.layer.masksToBounds = YES;
    [self.tableView addHeaderWithTarget:self action:@selector(pullDown)];
    [self.tableView addFooterWithTarget:self action:@selector(pullUp)];
    [self.tableView headerBeginRefreshing];
}

- (void)pullDown
{
    [CCUser getLikeListOfMember:self.parentMember withLimit:QueryLimit skip:0 block:^(NSArray *likeList, NSError *error) {
        [self.tableView headerEndRefreshing];
        if (error) {
            
        } else {
            self.itemList = [NSMutableArray arrayWithArray:likeList];
            [self.tableView reloadData];
        }
    }];
}

- (void)pullUp
{
    if (self.itemList.count < QueryLimit) {
        [self.tableView footerEndRefreshing];
        return;
    }
    [CCUser getLikeListOfMember:self.parentMember withLimit:QueryLimit skip:self.itemList.count block:^(NSArray *likeList, NSError *error) {
        if (!error) {
            [self.itemList addObjectsFromArray:likeList];
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
    return self.itemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCItem * item = self.itemList[indexPath.row];
    ShopListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell" forIndexPath:indexPath];
    
    cell.rightPriceLabel.text = [@"￥" stringByAppendingString:[NSNumber numberWithFloat:item.price].stringValue];
    cell.rightTitleLabel.text = item.name;
    cell.rightLikeLabel.text = [NSString stringWithFormat:@"%ld人喜欢", (long)item.likeNum];
    [cell.rightImageView sd_setImageWithURL:[CCFile ccURLWithString:item.cover]];
    
    NSDateComponents * curDate = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:item.date];
    NSInteger curYear = [curDate year];
    NSInteger curMonth = [curDate month];
    
    NSDateComponents * preDate;
    if (indexPath.row > 0) {
        preDate = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:((CCItem *)self.itemList[indexPath.row - 1]).date];
    }
    
    if (indexPath.row == 0 || (preDate && ([preDate year]!= curYear || [preDate month]!= curMonth))) {
        cell.leftView.hidden = NO;
        cell.leftDayLabel.text = [NSNumber numberWithInteger:curYear % 100].stringValue;
        cell.leftMonthLabel.text = [NSString stringWithFormat:@"%ld月", (long)curMonth];
        cell.leftInfoLabel.text = [NSString stringWithFormat:@"上新%lu件", item.newCount];
    } else cell.leftView.hidden = YES;
    return cell;

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
