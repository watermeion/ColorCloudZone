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

//计算大小
static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

static  NSString  const *recommendCellIdentifier = @"RecommendItemsCollectionViewCell";
static  NSString  const *moreCellIdentifier = @"MoreItemsCollectionViewCell.h";
static const NSInteger cellNum = 4;

static const CGFloat cellHeight = 130;
static const CGFloat CellWidth = 220;



@interface GoodDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;




//View Part 3
@property (strong, nonatomic) IBOutlet DetailImageCollectionViewController *detailImageCollectionViewController;

@end






@implementation GoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      [self.collectionView registerClass:[MoreItemsCollectionViewCell class] forCellWithReuseIdentifier:moreCellIdentifier];
    
    
    
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


@end
