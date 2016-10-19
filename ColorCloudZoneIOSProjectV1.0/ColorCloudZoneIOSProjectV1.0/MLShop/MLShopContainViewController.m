//
//  MLShopContainViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/21.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "MLShopContainViewController.h"
#import "ShopContentCollectionViewCell.h"
#import "marcoHeader.h"
#import "UIImageView+WebCache.h"
#import "AddMemberShipViewController.h"
#import "MLShopViewController.h"
#import "ShopListTableViewCell.h"
#import "MJRefresh.h"
#import "GoodDetailViewController.h"
#import "SupplierViewController.h"
#import "CCItem.h"
#import "CCUser.h"
#import "CCFile.h"

#define QueryLimit 20

@interface MLShopContainViewController ()

@property (nonatomic, strong) NSMutableArray * hottestDataArray;
@property (nonatomic, strong) NSMutableArray * newestDataArray;

@property (nonatomic, strong) CCSaleMarket * selectedSaleMarket;
@property (nonatomic, strong) CCItemClass * selectedClass;
@property (nonatomic, strong) CCItemSort * selectedSort;


@end

@implementation MLShopContainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, MainScreenWidth,  self.collectionView.frame.size.height);
    [self.collectionView addHeaderWithTarget:self action:@selector(collectionViewPullDown)];
    [self.collectionView addFooterWithTarget:self action:@selector(collectionViewPullUp)];
    [self.collectionView headerBeginRefreshing];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    [self.tableView addHeaderWithTarget:self action:@selector(tableViewPullDown)];
    [self.tableView addFooterWithTarget:self action:@selector(tableViewPullUp)];
    [self.tableView headerBeginRefreshing];
    
}

- (NSString *)button1Title
{
    if ([self.parentVC isKindOfClass:[MarketViewController class]]) return @"买手推荐";
    else return @"最热";
}

- (NSString *)button2Title
{
    if ([self.parentVC isKindOfClass:[MarketViewController class]]) return @"最新潮流";
    else return @"最新";
}

- (void)marketViewController:(MarketViewController *)viewController didSelectSaleMarket:(CCSaleMarket *)saleMarket
{
    self.selectedSaleMarket = saleMarket;
    [self.collectionView headerBeginRefreshing];
    [self.tableView headerBeginRefreshing];
}

- (void)marketViewController:(MarketViewController *)viewController didSelectClass:(CCItemClass *)itemClass sort:(CCItemSort *)sort
{
    self.selectedClass = itemClass;
    self.selectedSort = sort;
    [self.collectionView headerBeginRefreshing];
    [self.tableView headerBeginRefreshing];
}

- (void)collectionViewPullDown
{
    if ([self.parentVC isKindOfClass:[MLShopViewController class]]) {
        [CCItem getItemListByHottest:YES forMall:[CCUser currentUser].userId withLimit:QueryLimit skip:0 block:^(NSArray *itemList, NSError *error) {
            [self.collectionView headerEndRefreshing];
            if (!error) {
                _hottestDataArray = [[NSMutableArray alloc] initWithArray:itemList];
                [self.collectionView reloadData];
            }
        }];
    } else if ([self. parentVC isKindOfClass:[SupplierViewController class]]) {
        [CCItem getItemListByHottest:YES forFactory:(self.parentUser?self.parentUser:[CCUser currentUser]).userId withLimit:QueryLimit skip:0 block:^(NSArray *itemList, NSError *error) {
            [self.collectionView headerEndRefreshing];
            if (!error) {
                _hottestDataArray = [[NSMutableArray alloc] initWithArray:itemList];
                [self.collectionView reloadData];
            }
        }];
    } else {
        [CCItem getItemListByHottest:YES saleMarketId:self.selectedSaleMarket.saleMarketId classId:self.selectedClass.classId sortId:self.selectedSort.sortId withLimit:QueryLimit skip:0 block:^(NSArray *itemList, NSError *error) {
            [self.collectionView headerEndRefreshing];
            if (!error) {
                _hottestDataArray = [[NSMutableArray alloc] initWithArray:itemList];
                [self.collectionView reloadData];
            }
        }];
    }
}

- (void)collectionViewPullUp
{
    if (_hottestDataArray.count < QueryLimit) {
        [self.collectionView footerEndRefreshing];
        return;
    }
    if ([self.parentVC isKindOfClass:[MLShopViewController class]]) {
        [CCItem getItemListByHottest:YES forMall:[CCUser currentUser].userId withLimit:QueryLimit skip:_hottestDataArray.count block:^(NSArray *itemList, NSError *error) {
            [self.collectionView footerEndRefreshing];
            if (!error) {
                if (!_hottestDataArray) _hottestDataArray = [NSMutableArray array];
                [_hottestDataArray addObjectsFromArray:itemList];
                [self.collectionView reloadData];
            }
        }];
    } else if ([self. parentVC isKindOfClass:[SupplierViewController class]]) {
        [CCItem getItemListByHottest:YES forFactory:(self.parentUser?self.parentUser:[CCUser currentUser]).userId withLimit:QueryLimit skip:_hottestDataArray.count block:^(NSArray *itemList, NSError *error) {
            [self.collectionView footerEndRefreshing];
            if (!error) {
                if (!_hottestDataArray) _hottestDataArray = [NSMutableArray array];
                [_hottestDataArray addObjectsFromArray:itemList];
                [self.collectionView reloadData];
            }
        }];
    } else {
        [CCItem getItemListByHottest:YES saleMarketId:self.selectedSaleMarket.saleMarketId classId:self.selectedClass.classId sortId:self.selectedSort.sortId withLimit:QueryLimit skip:_hottestDataArray.count block:^(NSArray *itemList, NSError *error) {
            [self.collectionView footerEndRefreshing];
            if (!error) {
                if (!_hottestDataArray) _hottestDataArray = [NSMutableArray array];
                [_hottestDataArray addObjectsFromArray:itemList];
                [self.collectionView reloadData];
            }
        }];
    }
}

- (void)tableViewPullDown
{
    if ([self.parentVC isKindOfClass:[MLShopViewController class]]) {
        [CCItem getItemListByHottest:NO forMall:[CCUser currentUser].userId withLimit:QueryLimit skip:0 block:^(NSArray *itemList, NSError *error) {
            [self.tableView headerEndRefreshing];
            if (!error) {
                _newestDataArray = [NSMutableArray arrayWithArray:itemList];
                [self.tableView reloadData];
            }
        }];
    } else if ([self. parentVC isKindOfClass:[SupplierViewController class]]) {
        [CCItem getItemListByHottest:NO forFactory:(self.parentUser?self.parentUser:[CCUser currentUser]).userId withLimit:QueryLimit skip:0 block:^(NSArray *itemList, NSError *error) {
            [self.tableView headerEndRefreshing];
            if (!error) {
                _newestDataArray = [NSMutableArray arrayWithArray:itemList];
                [self.tableView reloadData];
            }
        }];
    } else {
        [CCItem getItemListByHottest:NO saleMarketId:self.selectedSaleMarket.saleMarketId classId:self.selectedClass.classId sortId:self.selectedSort.sortId withLimit:QueryLimit skip:0 block:^(NSArray *itemList, NSError *error) {
            [self.tableView headerEndRefreshing];
            if (!error) {
                _newestDataArray = [NSMutableArray arrayWithArray:itemList];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)tableViewPullUp
{
    if (_newestDataArray.count < QueryLimit) {
        [self.tableView footerEndRefreshing];
        return;
    }
    if ([self.parentVC isKindOfClass:[MLShopViewController class]]) {
        [CCItem getItemListByHottest:NO forMall:[CCUser currentUser].userId withLimit:QueryLimit skip:_newestDataArray.count block:^(NSArray *itemList, NSError *error) {
            [self.tableView footerEndRefreshing];
            if (!error) {
                if (!_newestDataArray) _newestDataArray = [NSMutableArray array];
                [_newestDataArray addObjectsFromArray:itemList];
                [self.tableView reloadData];
            }
        }];
    } else if ([self. parentVC isKindOfClass:[SupplierViewController class]]) {
        [CCItem getItemListByHottest:NO forFactory:(self.parentUser?self.parentUser:[CCUser currentUser]).userId withLimit:QueryLimit skip:_newestDataArray.count block:^(NSArray *itemList, NSError *error) {
            [self.tableView footerEndRefreshing];
            if (!error) {
                if (!_newestDataArray) _newestDataArray = [NSMutableArray array];
                [_newestDataArray addObjectsFromArray:itemList];
                [self.tableView reloadData];
            }
        }];
    } else {
        [CCItem getItemListByHottest:NO saleMarketId:self.selectedSaleMarket.saleMarketId classId:self.selectedClass.classId sortId:self.selectedSort.sortId withLimit:QueryLimit skip:_hottestDataArray.count block:^(NSArray *itemList, NSError *error) {
            [self.tableView footerEndRefreshing];
            if (!error) {
                if (!_newestDataArray) _newestDataArray = [NSMutableArray array];
                [_newestDataArray addObjectsFromArray:itemList];
                [self.tableView reloadData];
            }
        }];
    }
}


- (void)btn1Selected:(CustomSelectionBarView *)view
{
    self.collectionView.hidden = NO;
    self.tableView.hidden = YES;
}

- (void)btn2Selected:(CustomSelectionBarView *)view
{
    self.collectionView.hidden = YES;
    self.tableView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
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
#pragma mark <UICollectionViewDataSource>


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float widthMargins = 2;
    float width = ((MainScreenWidth - 4 * widthMargins) / 2);
    float height = (width / 180) * 300;

    return CGSizeMake(width, height);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake(5, 2, 5, 2);

}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.hottestDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ShopContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopContentCollectionViewCell" forIndexPath:indexPath];
    CCItem * item = [self.hottestDataArray objectAtIndex:indexPath.row];
    cell.likeNumLabel.text = [NSString stringWithFormat:@"%ld人喜欢", (long)item.likeNum];
    cell.titleLabel.text = item.name;
    cell.priceLabel.text = [@"￥" stringByAppendingString:[NSNumber numberWithFloat:item.price].stringValue];
    [cell.itemImageView sd_setImageWithURL:[CCFile ccURLWithString:item.cover]];
    return cell;
//    return nil;
}

#pragma mark <UICollectionViewDelegate>

 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CCItem * item = [self.hottestDataArray objectAtIndex:indexPath.row];
    GoodDetailViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    vc.parentItem = item;
    vc.parentVC = self.parentVC;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_newestDataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCItem * item = _newestDataArray[indexPath.row];
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
        preDate = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:((CCItem *)_newestDataArray[indexPath.row - 1]).date];
    }
    
    if (indexPath.row == 0 || (preDate && ([preDate year]!= curYear || [preDate month]!= curMonth))) {
        cell.leftView.hidden = NO;
        cell.leftDayLabel.text = [NSNumber numberWithInteger:curYear % 100].stringValue;
        cell.leftMonthLabel.text = [NSString stringWithFormat:@"%ld月", (long)curMonth];
        cell.leftInfoLabel.text = [NSString stringWithFormat:@"上新%lu件", item.newCount];
    } else cell.leftView.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CCItem * item = _newestDataArray[indexPath.row];
    GoodDetailViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    vc.parentItem = item;
    vc.parentVC = self.parentVC;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
