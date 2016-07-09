//
//  UpLoadViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 16/3/29.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "UpLoadViewController.h"
#import "ColorCloudZoneIOSProjectV1.0-Bridging-Header.h"
#import "CCItem.h"
#import "CCFile.h"
#import "SizeViewController.h"
#import "ColorViewController.h"
#import "TypeViewController.h"
#import "ClassViewController.h"
#import "MaterialViewController.h"
#import "GBImagePickerBehavior.h"
#import "UploadImagesViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "VPImageCropperViewController.h"
#import "UpLoadCollectionViewCell.h"
#import "UIImageView+WebCache.h"
static NSInteger kMaxInputWordNum = 50;
static NSInteger kMaxPicturesNum = 5;


static NSString *kUpLoadCoverIdentifier = @"kUpLoadCoverIdentifier";
static NSString *kUpLoadAssistIdentifier = @"kUpLoadAssistIdentifier";
static NSString *kUpLoadDscrpIdentifier = @"kUpLoadDscrpIdentifier";
static NSString *kShowUpLoadImageVCSegue = @"showUpLoadImageVC";
@interface UpLoadViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate, UIActionSheetDelegate, VPImageCropperDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *choosePictures;

@property (nonatomic) NSInteger pictureNum;

@property (nonatomic) NSUInteger indexWillDelete;
@property (nonatomic) NSArray *identifiers;

@property (nonatomic) NSDictionary *imageUploadData;


@end

@implementation UpLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    [self.itemPicCollectionView registerClass: [UpLoadPicBtnCollectionViewCell class] forCellWithReuseIdentifier:kUpLoadPicBtnCellIdentifier];
    //    [self.itemPicCollectionView registerClass:[UpLoadPictureCollectionViewCell class] forCellWithReuseIdentifier:kUpLoadPicCellIdentifier];
    self.identifiers = @[kUpLoadCoverIdentifier,kUpLoadAssistIdentifier,kUpLoadDscrpIdentifier];
    self.urlPlaceholderImage = [NSMutableDictionary dictionary];
    self.parentItem = [[CCItem alloc] init];
    self.pictureNum = 0;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.itemPicCollectionView reloadData];
    
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
    
    
    if (self.parentItem.extendProperty.value.length) self.surfaceMater.text = self.parentItem.extendProperty.value;
    else self.surfaceMater.text = @"请点击选择面料(可多选)";
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:kShowUpLoadImageVCSegue]) {
        UploadImagesViewController *vc = segue.destinationViewController;
        if ([sender isKindOfClass:[NSDictionary class]]) {
            vc.displayTitle = [sender objectForKey:@"title"];
            vc.maxImgs = [[sender objectForKey:@"Max"] integerValue];
            NSArray *displayArray = [sender objectForKey:@"displayImage"];
            if (displayArray.count>0) {
                vc.displayImages = displayArray;
            }
            if ([[sender objectForKey:@"title"] isEqualToString:@"选择背景图"]) {
                vc.currentImageArray = self.parentItem.assistantPics;
            } else {
                vc.currentImageArray = self.parentItem.descPics;
            }
            vc.urlPlaceholderImage = self.urlPlaceholderImage;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [self.identifiers objectAtIndex:indexPath.row];
    NSDictionary *dict;
    if ([identifier isEqualToString:kUpLoadCoverIdentifier]) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传封面图片"
                                                                  delegate:self
                                                         cancelButtonTitle:@"取消"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"从相册上传", @"拍照", nil];
        [actionSheet showInView:self.view];
        
    }else if([identifier isEqualToString:kUpLoadAssistIdentifier]){
    
        dict = @{@"title":@"选择背景图",@"Max":@(kMaxPicturesNum),@"displayImage":@[]};
    }else if([identifier isEqualToString:kUpLoadDscrpIdentifier]){
     dict = @{@"title":@"选择描述封面",@"Max":@(kMaxPicturesNum),@"displayImage":@[]};
    }
    
    if (dict == nil) {
        return;
    }
    [self performSegueWithIdentifier:kShowUpLoadImageVCSegue sender:dict];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UpLoadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self.identifiers objectAtIndex:indexPath.row] forIndexPath:indexPath];
    NSString *identifier = [self.identifiers objectAtIndex:indexPath.row];
    if ([identifier isEqualToString:kUpLoadCoverIdentifier]) {
        if (self.parentItem.cover)
            [cell.uploadedImageView sd_setImageWithURL:[CCFile ccURLWithString:self.parentItem.cover] placeholderImage:[self.urlPlaceholderImage objectForKey:self.parentItem.cover]];
    }else if([identifier isEqualToString:kUpLoadAssistIdentifier]){
        if (self.parentItem.assistantPics.count > 0) {
            NSString * url = [self.parentItem.assistantPics firstObject];
            [cell.uploadedImageView sd_setImageWithURL:[CCFile ccURLWithString:url] placeholderImage:[self.urlPlaceholderImage objectForKey:url]];
        }
        
    }else if([identifier isEqualToString:kUpLoadDscrpIdentifier]){
        if (self.parentItem.descPics.count > 0) {
            NSString * url = [self.parentItem.descPics firstObject];
            [cell.uploadedImageView sd_setImageWithURL:[CCFile ccURLWithString:url] placeholderImage:[self.urlPlaceholderImage objectForKey:url]];
        }
    }

    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.identifiers.count;
}

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 60) / 3.0, 130);
}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//上 左 下 右
}

- (IBAction)cancelClicked:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确认要取消上传吗？"
                                                     message:@"取消后当前页的内容将不被保存。"
                                                    delegate:self
                                           cancelButtonTitle:@"继续上传"
                                           otherButtonTitles:@"确认取消", nil];
    alert.tag = 1000;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


- (IBAction)doneBtnAction:(id)sender {
    if (!(_itemName.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写商品名称"];
        return;
    }
    if (!(_itemSerialNum.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写商品货号"];
        return;
    }
    if (!(_itemWholeSalePrice.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写商品价格"];
        return;
    }
    if (!(self.parentItem.cover.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请上传商品封面图片"];
        return;
    }
    if (!(self.parentItem.assistantPics.count > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请上传商品主照片"];
        return;
    }
    if (!(self.parentItem.descPics.count > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请上传商品幅照片"];
        return;
    }
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
    if (!(self.parentItem.extendProperty.valueId.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请选择商品面料"];
        return;
    }
    self.parentItem.name = _itemName.text;
    self.parentItem.SN = _itemSerialNum.text;
    self.parentItem.price = [_itemWholeSalePrice.text floatValue];
    self.parentItem.desc = _itemDetailInputView.text;
    [SVProgressHUD showWithStatus:@"正在上传中"];
    [CCItem uploadItem:self.parentItem withBlock:^(CCItem *item, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        } else {
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
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

//类别
- (IBAction)chooseCategoryAction:(id)sender {
    ClassViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ClassViewController"];
    vc.parentItem = self.parentItem;
    vc.uploadViewController = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [controller.navigationBar setTranslucent:NO];
                //                controller.view.tintColor = [UIColor whiteColor];
                [self presentViewController:controller animated:YES completion:nil];
            }
            break;
        }
        case 1: {
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                     if(status == ALAuthorizationStatusAuthorized){
                                         [[UIApplication sharedApplication] setStatusBarHidden:YES];
                                     }else{
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机"
                                                                                         message:@"请在iPhone的“设置－隐私－相机”中允许访问相机"
                                                                                        delegate:self
                                                                               cancelButtonTitle:@"确定"
                                                                               otherButtonTitles:nil, nil];
                                         [alert show];
                                     }
                                 }];
            }
            break;
        }
        default:
            break;
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    // 裁剪
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, (height - width / 0.75) / 2.0, width, width / 0.75) limitScaleRatio:3.0];
    imgEditorVC.delegate = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:imgEditorVC animated:YES completion:^{
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD showWithStatus:@"正在上传图片" maskType:SVProgressHUDMaskTypeBlack];
        [CCFile uploadImage:editedImage withProgress:nil completionBlock:^(NSString *url, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                if (self.parentItem.cover) {
                    [self.urlPlaceholderImage removeObjectForKey:self.parentItem.cover];
                }
                self.parentItem.cover = url;
                [self.urlPlaceholderImage setValue:editedImage forKey:url];
                [self.itemPicCollectionView reloadData];
            }
        }];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}


- (BOOL) isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


@end
