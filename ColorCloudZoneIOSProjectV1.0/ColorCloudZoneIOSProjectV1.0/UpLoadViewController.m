//
//  UpLoadViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 16/3/29.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "UpLoadViewController.h"
#import "ColorCloudZoneIOSProjectV1.0-Bridging-Header.h"
#import "UpLoadPicBtnCollectionViewCell.h"
#import "UpLoadPictureCollectionViewCell.h"

static NSInteger kMaxInputWordNum = 50;
static NSInteger kMaxPicturesNum = 5;
static NSString *kUpLoadPicBtnCellIdentifier = @"UpLoadPictureBtnCollectionViewCell";
static NSString *kUpLoadPicCellIdentifier = @"UpLoadPicCollectionViewCell";

@interface UpLoadViewController ()<GBTableViewSelectorBehaviorDelegate,GBTableViewSelectorResultDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *choosePictures;


@end

@implementation UpLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selector = [[GBTableViewSelectorBehavior alloc] init];
    self.selector.delegate = self;
    self.selector.owner = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.itemPicCollectionView registerClass: [UpLoadPicBtnCollectionViewCell class] forCellWithReuseIdentifier:kUpLoadPicBtnCellIdentifier];
    [self.itemPicCollectionView registerClass:[UpLoadPictureCollectionViewCell class] forCellWithReuseIdentifier:kUpLoadPicCellIdentifier];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUpLoadPicBtnCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    UpLoadPictureCollectionViewCell *picCell = [collectionView dequeueReusableCellWithReuseIdentifier:kUpLoadPicCellIdentifier forIndexPath:indexPath];
    
    //config cell
    
    return picCell;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1 + self.choosePictures.count;
}








- (IBAction)itemCategoryBtn:(id)sender {
}
- (IBAction)chooseColorAction:(id)sender {
}
- (IBAction)chooseSurfaceAction:(id)sender {
}

- (IBAction)upLoadImagesAction:(id)sender {
}

- (IBAction)chooseCategoryAction:(id)sender {
}
@end
