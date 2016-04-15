
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
#import "SVProgressHud.h"
#import "DCPicScrollView.h"
#import "DCWebImageManager.h"
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
        [self.collectButton setTitle:self.parentItem.isCollected?@"已收藏":@"收藏" forState:UIControlStateNormal];
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
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _likeLabel.text = [NSString stringWithFormat:@"%ld人想要", (long)self.parentItem.likeNum];
    _titleLabel.text = self.parentItem.name;
    _itemSNLabel.text = [@"编号:" stringByAppendingString:self.parentItem.SN];
    [SVProgressHUD showWithStatus:@"正在获取信息"];
    [CCItem getItemDetailInfo:self.parentItem withBlock:^(CCItem *item, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        } else {
            [self setBannerView];
            _materialLabel.text = [@"面料: " stringByAppendingString:self.parentItem.extendProperty.value];
            _descLabel.text = (self.parentItem.desc.length > 0)?self.parentItem.desc:@"无。";
        }
    }];
    
    
    
    [self.collectionView registerClass:[MoreItemsCollectionViewCell class] forCellWithReuseIdentifier:moreCellIdentifier];
}

- (void)setBannerView
{
    NSMutableArray *UrlStringArray = [NSMutableArray array];
//    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSString * url in self.parentItem.assistantPics) {
        [UrlStringArray addObject:[CCFile ccURLWithString:url].absoluteString];
    }
    
    DCPicScrollView  *picView = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 254) WithImageUrls:UrlStringArray];
    picView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:picView];
    
    //显示顺序和数组顺序一致
    //设置标题显示文本数组
    
    picView.style = PageControlAtCenter;
    
    //            picView.titleData = titleArray;
    
    //占位图片,你可以在下载图片失败处修改占位图片
    picView.placeImage = [UIImage imageNamed:@"uialq.jpg"];
    
    //图片被点击事件,当前第几张图片被点击了,和数组顺序一致
    [picView setImageViewDidTapAtIndex:^(NSInteger index) {
        printf("第%zd张图片\n",index);
    }];
    
    //default is 2.0f,如果小于0.5不自动播放
    picView.AutoScrollDelay = 5.0f;
    //    picView.textColor = [UIColor redColor];
    //下载失败重复下载次数,默认不重复,
    [[DCWebImageManager shareManager] setDownloadImageRepeatCount:1];
    //图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
    //error错误信息
    //url下载失败的imageurl
    [[DCWebImageManager shareManager] setDownLoadImageError:^(NSError *error, NSString *url) {
        NSLog(@"%@",error);
    }];
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
