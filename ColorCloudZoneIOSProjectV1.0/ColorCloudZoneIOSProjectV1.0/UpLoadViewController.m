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
#import "CCItem.h"
#import "SizeViewController.h"
#import "ColorViewController.h"
#import "TypeViewController.h"
#import "ClassViewController.h"
#import "MaterialViewController.h"
static NSInteger kMaxInputWordNum = 50;
static NSInteger kMaxPicturesNum = 5;
static NSString *kUpLoadPicBtnCellIdentifier = @"UpLoadPictureBtnCollectionViewCell";
static NSString *kUpLoadPicCellIdentifier = @"UpLoadPicCollectionViewCell";

@interface UpLoadViewController ()<GBTableViewSelectorBehaviorDelegate,GBTableViewSelectorResultDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *choosePictures;

@property (nonatomic, strong) CCItem * parentItem;

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
    

    self.parentItem = [[CCItem alloc] init];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.parentItem.itemClass.className) self.categoryLabel.text = [NSString stringWithFormat:@"%@ %@", self.parentItem.itemClass.className, self.parentItem.itemSort.sortName?self.parentItem.itemSort.sortName:@""];
    if (self.parentItem.itemType.name) self.typeLabel.text = self.parentItem.itemType.name;
    
    NSString * colors = @"";
    for (CCItemPropertyValue * prop in self.parentItem.colorProperty)
        colors = [NSString stringWithFormat:@"%@%@ ", colors, prop.value];
    if (colors.length) self.colorLabel.text = colors;
    else self.colorLabel.text = @"请点击选择颜色(可多选)";
    
    NSString * sizes = @"";
    for (CCItemPropertyValue * prop in self.parentItem.sizeProperty)
        sizes = [NSString stringWithFormat:@"%@%@ ", sizes, prop.value];
    if (sizes.length) self.sizeLabel.text = sizes;
    else self.sizeLabel.text = @"请点击选择尺码(可多选)";
    
    
    NSString * extends = @"";
    for (CCItemPropertyValue * prop in self.parentItem.extendProperty)
        extends = [NSString stringWithFormat:@"%@%@ ", extends, prop.value];
    if (extends.length) self.surfaceMater.text = extends;
    else self.surfaceMater.text = @"请点击选择面料(可多选)";
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



- (IBAction)doneBtnAction:(id)sender {
    if (!(_itemName.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写商品名称"];
        return;
    }
    if (!(_itemSerialNum.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写商品款号"];
        return;
    }
    if (!(_itemWholeSalePrice.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写商品价格"];
        return;
    }
//    if (!(self.parentItem.cover.length > 0)) {
//        [SVProgressHUD showErrorWithStatus:@"请上传商品封面图片"];
//        return;
//    }
//    if (!(self.parentItem.assistantPics.count > 0)) {
//        [SVProgressHUD showErrorWithStatus:@"请上传商品主照片"];
//        return;
//    }
//    if (!(self.parentItem.descPics.count > 0)) {
//        [SVProgressHUD showErrorWithStatus:@"请上传商品幅照片"];
//        return;
//    }
    if (!self.parentItem.itemClass) {
        [SVProgressHUD showErrorWithStatus:@"请选择商品类别"];
        return;
    }
    if (!self.parentItem.itemSort) {
        [SVProgressHUD showErrorWithStatus:@"请选择商品类别"];
        return;
    }
    if (!self.parentItem.itemType) {
        [SVProgressHUD showErrorWithStatus:@"请选择商品类型"];
        return;
    }
    if (!(self.parentItem.colorProperty.count > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请选择商品颜色"];
        return;
    }
    if (!(self.parentItem.sizeProperty.count > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请选择商品尺寸"];
        return;
    }
    if (!(self.parentItem.extendProperty.count > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请选择商品面料"];
        return;
    }
    self.parentItem.name = _itemName.text;
    self.parentItem.SN = _itemSerialNum.text;
    self.parentItem.price = [_itemWholeSalePrice.text floatValue];
    self.parentItem.desc = _itemDetailInputView.text;
    [SVProgressHUD showWithStatus:@"正在上传中"];
    [CCItem uploadItem:self.parentItem withBlock:^(CCItem *item, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}


//尺码
- (IBAction)chooseSizeAction:(id)sender {
    if (!self.parentItem.itemType.typeId) {
        [SVProgressHUD showErrorWithStatus:@"请先选择商品类型！"];
        return;
    }
    SizeViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SizeViewController"];
    vc.parentItem = self.parentItem;
    [self.navigationController pushViewController:vc animated:YES];
}
//类型
- (IBAction)chooseTypeAction:(id)sender {
    TypeViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TypeViewController"];
    vc.parentItem = self.parentItem;
    [self.navigationController pushViewController:vc animated:YES];
}
//颜色
- (IBAction)chooseColorAction:(id)sender {
    if (!self.parentItem.itemType.typeId) {
        [SVProgressHUD showErrorWithStatus:@"请先选择商品类型！"];
        return;
    }
    ColorViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ColorViewController"];
    vc.parentItem = self.parentItem;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//面料
- (IBAction)chooseSurfaceAction:(id)sender {
    if (!self.parentItem.itemType.typeId) {
        [SVProgressHUD showErrorWithStatus:@"请先选择商品类型！"];
        return;
    }
    MaterialViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MaterialViewController"];
    vc.parentItem = self.parentItem;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)upLoadImagesAction:(id)sender {
    
}
//类别
- (IBAction)chooseCategoryAction:(id)sender {
    ClassViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ClassViewController"];
    vc.parentItem = self.parentItem;
    vc.uploadViewController = self;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
