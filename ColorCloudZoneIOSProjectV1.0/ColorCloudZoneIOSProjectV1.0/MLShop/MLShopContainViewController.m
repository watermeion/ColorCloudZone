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
#import "MarketViewController.h"
#import "ShopListTableViewCell.h"
#import "MJRefresh.h"
#import "GoodDetailViewController.h"
#import "SupplierViewController.h"

#define QueryLimit 30

@interface MLShopContainViewController ()

@property (nonatomic, strong) NSMutableArray * hottestDataArray;
@property (nonatomic, strong) NSMutableArray * newestDataArray;
@property (nonatomic, strong) NSMutableArray * newestProducts;

@end

@implementation MLShopContainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)collectionViewPullDown
{
    if ([self.parentVC isKindOfClass:[MLShopViewController class]]) {
        [self getShopProductsHottest:YES withLimit:QueryLimit skip:0 block:^(NSArray *objects, NSError *error) {
            [self.collectionView headerEndRefreshing];
            if (!error) {
                _hottestDataArray = [[NSMutableArray alloc] initWithArray:objects];
                [self.collectionView reloadData];
            }
        }];
    } else {
        [self getMarketProductsHottest:YES withLimit:QueryLimit skip:0 block:^(NSArray *objects, NSError *error) {
            [self.collectionView headerEndRefreshing];
            if (!error) {
                _hottestDataArray = [[NSMutableArray alloc] initWithArray:objects];
                [self.collectionView reloadData];
            }
        }];
    }
}

- (void)collectionViewPullUp
{
    if ([self.parentVC isKindOfClass:[MLShopViewController class]]) {
        [self getShopProductsHottest:YES withLimit:QueryLimit skip:_hottestDataArray.count block:^(NSArray *objects, NSError *error) {
            [self.collectionView footerEndRefreshing];
            if (!error) {
                if (!_hottestDataArray) _hottestDataArray = [NSMutableArray array];
                [_hottestDataArray addObjectsFromArray:objects];
                [self.collectionView reloadData];
            }
        }];
    } else {
        [self getMarketProductsHottest:YES withLimit:QueryLimit skip:_hottestDataArray.count block:^(NSArray *objects, NSError *error) {
            [self.collectionView footerEndRefreshing];
            if (!error) {
                if (!_hottestDataArray) _hottestDataArray = [NSMutableArray array];
                [_hottestDataArray addObjectsFromArray:objects];
                [self.collectionView reloadData];
            }
        }];
    }
}

- (void)tableViewPullDown
{
    if ([self.parentVC isKindOfClass:[MLShopViewController class]]) {
        [self getShopProductsHottest:NO withLimit:QueryLimit skip:0 block:^(NSArray *objects, NSError *error) {
            [self.tableView headerEndRefreshing];
            if (!error) {
                _newestProducts = [NSMutableArray arrayWithArray:objects];
                [self figureNewestDataArray];
                [self.tableView reloadData];
            }
        }];
    } else {
        [self getMarketProductsHottest:NO withLimit:QueryLimit skip:0 block:^(NSArray *objects, NSError *error) {
            [self.tableView headerEndRefreshing];
            if (!error) {
                _newestProducts = [NSMutableArray arrayWithArray:objects];
                [self figureNewestDataArray];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)tableViewPullUp
{
    if ([self.parentVC isKindOfClass:[MLShopViewController class]]) {
        [self getShopProductsHottest:NO withLimit:QueryLimit skip:_newestProducts.count block:^(NSArray *objects, NSError *error) {
            [self.tableView footerEndRefreshing];
            if (!error) {
                if (!_newestProducts) _newestProducts = [NSMutableArray array];
                [_newestProducts addObjectsFromArray:objects];
                [self figureNewestDataArray];
                [self.tableView reloadData];
            }
        }];
    } else {
        [self getMarketProductsHottest:NO withLimit:QueryLimit skip:_newestProducts.count block:^(NSArray *objects, NSError *error) {
            [self.tableView footerEndRefreshing];
            if (!error) {
                if (!_newestProducts) _newestProducts = [NSMutableArray array];
                [_newestProducts addObjectsFromArray:objects];
                [self figureNewestDataArray];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)figureNewestDataArray
{
    _newestDataArray = [NSMutableArray array];
    NSMutableArray * currentDay;
    for (NSInteger index = 0; index < _newestProducts.count; index ++) {
        if (currentDay == nil) {
            currentDay = [NSMutableArray array];
        }
        if (index == 0) {
            [currentDay addObject:_newestProducts[index]];
        } else {
            AVObject * cur = _newestProducts[index];
            AVObject * pre = _newestProducts[index - 1];
            NSDateComponents * curDate = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:cur.createdAt];
            NSDateComponents * preDate = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:pre.createdAt];
            if ([curDate year] == [preDate year] && [curDate month] == [preDate month] && [curDate day] == [preDate day]) {
                [currentDay addObject:cur];
            } else {
                [_newestDataArray addObject:currentDay];
                currentDay = [NSMutableArray arrayWithObject:cur];
            }
            
        }
    }
    if (currentDay) [_newestDataArray addObject:currentDay];
}

- (void)getMarketProductsHottest:(BOOL)hottest withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void(^)(NSArray * objects, NSError *error)) block
{
    
    AVQuery * query = [AVQuery queryWithClassName:@"Product"];
    query.limit = limit;
    query.skip = skip;
    [query includeKey:@"productMainImage"];
    if ([self.parentVC isKindOfClass:[SupplierViewController class]]) {
        [query whereKey:@"userId" equalTo:[AVUser currentUser].objectId];
    }
    if (hottest) [query orderByDescending:@"like"];
    else [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

- (void)getShopProductsHottest:(BOOL)hottest withLimit:(NSInteger)limit skip:(NSInteger)skip block:(void(^)(NSArray * objects, NSError *error)) block
{
    AVQuery * query = [AVQuery queryWithClassName:@"MallProduct"];
    query.limit = limit;
    query.skip = skip;
    [query includeKey:@"factoryProduct"];
    [query whereKey:@"shopId" equalTo:((AVObject*)[[AVUser currentUser] objectForKey:@"shop"]).objectId];
    if (hottest) [query orderByDescending:@"like"];
    else [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray * products;
        if (!error) {
            products = [NSMutableArray array];
            for (AVObject * mallProduct in objects) {
                [products addObject:mallProduct[@"factoryProduct"]];
            }
        }
        block(products, error);
    }];
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
    AVObject * product = [self.hottestDataArray objectAtIndex:indexPath.row];
    cell.likeNumLabel.text = [((NSNumber *)product[@"like"]).stringValue stringByAppendingString:@"人喜欢"];
    cell.titleLabel.text = product[@"productName"];
    cell.priceLabel.text = [@"￥" stringByAppendingString:((NSNumber *)product[@"productPrice"]).stringValue];
    AVFile * file = product[@"productMainImage"];
    [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:file.url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
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
    AVObject * product = [_hottestDataArray objectAtIndex:indexPath.row];
    GoodDetailViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    vc.product = product;
    [self.navigationController pushViewController:vc animated:YES];
    
}

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_newestDataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray * currentDay = [_newestDataArray objectAtIndex:section];
    return currentDay.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * currentDay = _newestDataArray[indexPath.section];
    AVObject * product = currentDay[indexPath.row];
    ShopListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell" forIndexPath:indexPath];
    cell.rightPriceLabel.text = [@"￥" stringByAppendingString:((NSNumber*)product[@"productPrice"]).stringValue];
    cell.rightTitleLabel.text = product[@"productName"];
    cell.rightLikeLabel.text = ((NSNumber*)product[@"like"]).stringValue;
    
    AVFile * file = product[@"productMainImage"];
    [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:file.url]];
    
    if (indexPath.row == 0) {
        NSDateComponents * preDate = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:product.createdAt];
        cell.leftView.hidden = NO;
        cell.leftDayLabel.text = [NSNumber numberWithInteger:[preDate day]].stringValue;
        cell.leftMonthLabel.text = [NSString stringWithFormat:@"%ld月", (long)[preDate month]];
        cell.leftInfoLabel.text = [NSString stringWithFormat:@"上新%lu件", (unsigned long)currentDay.count];
    } else cell.leftView.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray * currentDay = _newestDataArray[indexPath.section];
    AVObject * product = currentDay[indexPath.row];
    GoodDetailViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    vc.product = product;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
