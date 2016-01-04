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
static NSString *const kAddMemberCollectonCellIdentifier = @"AddMemberCollectionViewCell";
static NSString *const kMemberCollectonCellIdentifier = @"MemberCommonCollectionViewCell";


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
    [self getMembersWithLimit:50 skip:0 block:^(NSArray *objects, NSError *error) {
        [self.collectionView headerEndRefreshing];
        if (!error) {
            self.dataSource = [NSMutableArray arrayWithArray:objects];
            [self.collectionView reloadData];
        }
    }];
}

- (void)pullUp
{
    [self getMembersWithLimit:50 skip:self.dataSource.count block:^(NSArray *objects, NSError *error) {
        [self.collectionView footerEndRefreshing];
        if (!error) {
            if (!self.dataSource) self.dataSource = [NSMutableArray array];
            [self.dataSource addObjectsFromArray:objects];
            [self.collectionView reloadData];
        }
    }];
}

- (void)getMembersWithLimit:(NSInteger)limit skip:(NSInteger)skip block:(void(^)(NSArray * objects, NSError *error)) block
{
    AVObject * shop = [[AVUser currentUser] objectForKey:@"shop"];
    [shop fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            AVRelation * relation = [object relationforKey:@"shopMember"];
            AVQuery * query = [relation query];
            query.limit = limit;
            query.skip = skip;
            [query orderByDescending:@"createdAt"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                block(objects, error);
            }];
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
    AVObject * member = [_dataSource objectAtIndex:indexPath.item - 1];
    cell.nameLabel.text = member[@"MemberName"];
    cell.phoneLabel.text = member[@"MemberMobile"];
    NSString * url = ((AVFile *)member[@"MemberLogoUrl"]).url;
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:url]];
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
    }
}




@end
