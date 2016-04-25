//
//  MemerShipViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/16.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "MemerShipViewController.h"
#import "MemberCommonCollectionViewCell.h"
#import "AddMemberCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "AddMemberShipViewController.h"
#import "MJRefresh/MJRefresh.h"
#import "CCFile.h"
#import "CCUser.h"
#import "MemberProfileViewController.h"



static NSString *const kAddMemberCollectonCellIdentifier = @"AddMemberCollectionViewCell";
static NSString *const kMemberCollectonCellIdentifier = @"MemberCommonCollectionViewCell";

static const NSInteger QueryLimit = 30;

@interface MemerShipViewController ()
@property (nonatomic, strong) NSMutableArray * dataSource;
@end

@implementation MemerShipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView addHeaderWithTarget:self action:@selector(pullDown)];
    [self.collectionView addFooterWithTarget:self action:@selector(pullUp)];
    [self.collectionView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)pullDown
{
    [CCUser getMemberListByMallId:[CCUser currentUser].userId withLimit:QueryLimit skip:0 block:^(NSArray *memberList, NSError *error) {
        [self.collectionView headerEndRefreshing];
        if (!error) {
            self.dataSource = [NSMutableArray arrayWithArray:memberList];
            [self.collectionView reloadData];
        }
    }];
}

- (void)pullUp
{
    if (self.dataSource.count < QueryLimit) {
        [self.collectionView footerEndRefreshing];
        return;
    }
    [CCUser getMemberListByMallId:[CCUser currentUser].userId withLimit:QueryLimit skip:self.dataSource.count block:^(NSArray *memberList, NSError *error) {
        [self.collectionView footerEndRefreshing];
        if (!error) {
            if (!self.dataSource) self.dataSource = [NSMutableArray array];
            [self.dataSource addObjectsFromArray:memberList];
            [self.collectionView reloadData];
        }
    }];
}




#pragma mark - UICOllectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 1 + _dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.item == 0) {
        AddMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddMemberCollectonCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    MemberCommonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMemberCollectonCellIdentifier forIndexPath:indexPath];
    CCMember * member = [_dataSource objectAtIndex:indexPath.item - 1];
    cell.nameLabel.text = member.username;
    cell.phoneLabel.text = member.mobile;
    [cell.avatarImageView sd_setImageWithURL:[CCFile ccURLWithString:member.headImgUrl]];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        AddMemberShipViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddMemberShipViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CCMember * member = [_dataSource objectAtIndex:indexPath.item - 1];
        MemberProfileViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberProfileViewController"];
        vc.parentMember = member;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 20) / 3.0, 160.f);
}

@end
