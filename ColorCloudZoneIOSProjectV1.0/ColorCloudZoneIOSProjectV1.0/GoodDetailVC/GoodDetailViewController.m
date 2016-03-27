//
//  GoodDetailViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/5.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "RecommendItemsCollectionViewCell.h"
#import "MoreItemsCollectionViewCell.h"
#import "DetailImageCollectionViewController.h"
#import "UIImageView+WebCache.h"
#import "MarketViewController.h"
#import "MLShopViewController.h"
#import "SupplierViewController.h"
#import "KxMenu.h"
#import "CollectAlertView.h"
#import "WantView.h"
//计算大小
static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

static  NSString *recommendCellIdentifier = @"RecommendItemsCollectionViewCell";
static  NSString *moreCellIdentifier = @"MoreItemsCollectionViewCell";
static const NSInteger cellNum = 4;

static const CGFloat cellHeight = 130;
static const CGFloat CellWidth = 220;



@interface GoodDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, CollectAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//View Part 3
@property (strong, nonatomic) IBOutlet DetailImageCollectionViewController *detailImageCollectionViewController;
@property (strong, nonatomic) NSArray * menuItems;
@end

@implementation GoodDetailViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.parentVC isKindOfClass:[MLShopViewController class]]) {
        self.wantView.hidden = NO;
        self.contactAndCollectView.hidden = YES;
        _menuItems = @[[KxMenuItem menuItem:@"取消收藏"
                                      image:nil
                                     target:self
                                     action:@selector(uncollect:)],
                       [KxMenuItem menuItem:@"统计"
                                      image:nil
                                     target:nil
                                     action:NULL]];
    } else if ([self.parentVC isKindOfClass:[MarketViewController class]]) {
        self.wantView.hidden = YES;
        self.contactAndCollectView.hidden = NO;
    } else {
        self.wantView.hidden = YES;
        self.contactAndCollectView.hidden = YES;
        _menuItems = @[[KxMenuItem menuItem:@"编辑"
                                      image:nil
                                     target:nil
                                     action:NULL],
                       [KxMenuItem menuItem:@"下架"
                                      image:nil
                                     target:self
                                     action:@selector(unsell:)],
                       [KxMenuItem menuItem:@"统计"
                                      image:nil
                                     target:nil
                                     action:NULL]];
    }
    if (_menuItems) {
        
        UIBarButtonItem *moreFeaturesLeftBarItem = [[UIBarButtonItem alloc]
                                                    initWithImage:[UIImage imageNamed:@"moreBarIcon_black"]
                                                    style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(moreFeaturesLeftBarAction:)];
        moreFeaturesLeftBarItem.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem = moreFeaturesLeftBarItem;
    }
    
    AVFile * mainImage = [_product objectForKey:@"productMainImage"];
    [_productMainImageView sd_setImageWithURL:[NSURL URLWithString:mainImage.url]];
    _likeLabel.text = [((NSNumber *)_product[@"like"]).stringValue stringByAppendingString:@"人想要"];
    _titleLabel.text = _product[@"productName"];
    AVObject * factory = [_product objectForKey:@"factory"];
    [factory fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            _factoryName.text = [factory objectForKey:@"name"];
            _factoryPhone.text = [factory objectForKey:@"phoneNumber"];
//            _factoryProductCount.text = [factory objectForKey:@""];
//            _factoryNewCount.text = [factory objectForKey:@""];
            AVFile * avatar = [factory objectForKey:@"avatar"];
            [_factoryAvatar sd_setImageWithURL:[NSURL URLWithString:avatar.url]];
        }
    }];
    
    
    
      [self.collectionView registerClass:[MoreItemsCollectionViewCell class] forCellWithReuseIdentifier:moreCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moreFeaturesLeftBarAction:(id)sender
{
    
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"下架"
                     image:nil
                    target:self
                    action:NULL],
      [KxMenuItem menuItem:@"统计"
                     image:nil
                    target:nil
                    action:NULL]
      ];
    
    //
    //    KxMenuItem *first = menuItems[0];
    //    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    //    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:CGRectMake(self.view.frame.size.width - 44 - 10, 0, 44, 54)
                 menuItems:menuItems];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma --mark UICollectionViewDataSourceDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return cellNum;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.item == cellNum -1) {
        MoreItemsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moreCellIdentifier forIndexPath:indexPath];
        return  cell;
        
    }
    RecommendItemsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:recommendCellIdentifier forIndexPath:indexPath];
    
    return cell;
}


#pragma --mark UICollectionViewDelegate


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout {

    //动态计算不同设备下 UIEdgeInsets 的值
    
    CGFloat itemsMargins = (CGRectGetWidth(self.view.frame) - CellWidth * 2)/3;
//    CGFloat linesMargins =  itemsMargins*1.5;
    
    return UIEdgeInsetsMake(0, itemsMargins, 0, itemsMargins);
}


- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
  //当sizeclasses 改变之后的做法
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (IBAction)collect:(id)sender
{
    
//    AVQuery * query = [AVQuery queryWithClassName:@"MallProduct"];
//    [query whereKey:@"factoryProduct" equalTo:self.product];
//    [query whereKey:@"shopId" equalTo:((AVObject *)[AVUser currentUser][@"shop"]).objectId];
//    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//        if (error) {
//            
//        } else {
//            
//        }
//    }];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CollectAlertView" owner:self options:nil];
    CollectAlertView *collectView = collectView = [nib objectAtIndex:0];
    [collectView showInView:self.view];
}

- (IBAction)uncollect:(id)sender
{
    
}

- (IBAction)contactFactory:(id)sender
{
    
}

- (IBAction)want:(id)sender
{
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WantView" owner:self options:nil];
    WantView * wantView = [nib objectAtIndex:0];
    [wantView showInView:self.view];
}

- (IBAction)unsell:(id)sender
{
    
}

@end
