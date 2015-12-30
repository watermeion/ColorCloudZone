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

@interface MLShopContainViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MLShopContainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, MainScreenWidth,  self.collectionView.frame.size.height);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    
    [self getProductsWithLimit:30 skip:0 block:^(NSArray *objects, NSError *error) {
        if (!error) {
            _dataArray = [[NSMutableArray alloc] initWithArray:objects];
            [self.collectionView reloadData];
        }
    }];

}

- (void)getProductsWithLimit:(NSInteger)limit skip:(NSInteger)skip block:(void(^)(NSArray * objects, NSError *error)) block
{
    
    AVQuery * query = [AVQuery queryWithClassName:@"Product"];
    query.limit = limit;
    query.skip = skip;
    [query includeKey:@"productMainImage"];
    [query orderByDescending:@"like"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];

}

- (void)getShopProductsWithLimit:(NSInteger)limit skip:(NSInteger)skip block:(void(^)(NSArray * objects, NSError *error)) block
{
    AVQuery * query = [AVQuery queryWithClassName:@"MallProduct"];
    query.limit = limit;
    query.skip = skip;
    [query includeKey:@"factoryProduct"];
    [query whereKey:@"shopId" equalTo:((AVObject*)[[AVUser currentUser] objectForKey:@"shop"]).objectId];
    [query orderByDescending:@"like"];
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

    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ShopContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopContentCollectionViewCell" forIndexPath:indexPath];
    AVObject * product = [self.dataArray objectAtIndex:indexPath.row];
    cell.likeNumLabel.text = [((NSNumber *)product[@"like"]).stringValue stringByAppendingString:@"人喜欢"];
    cell.titleLabel.text = product[@"productName"];
    cell.priceLabel.text = [@"￥" stringByAppendingString:((NSNumber *)product[@"productPrice"]).stringValue];
//     Configure the cell
//    cell.backgroundColor=[UIColor redColor];
//    cell.itemImageView.image = [self.dataArray objectAtIndex:indexPath.row];
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
    if (indexPath.item == 0) {
        
    }
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
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
