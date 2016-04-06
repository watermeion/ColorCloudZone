//
//  CompanyProfileViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/16.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "CompanyProfileViewController.h"
#import "MLTabBarViewController.h"
#import "SVProgressHud.h"
#import "VPImageCropper/VPImageCropperViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "CCFile.h"
#import "ProvinceViewController.h"
#import "SaleMarketViewController.h"
#import "UIImageView+WebCache.h"
@interface CompanyProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>
@property (nonatomic, strong) UIImage * avatar;
@end

@implementation CompanyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([CCUser currentUser]) {
        
        [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:[CCUser currentUser].headImgUrl]];
        self.comNameTextField.text = [CCUser currentUser].factoryName;
        self.ownerTextField.text = [CCUser currentUser].ownerName;
        self.comAddressTextField.text = [CCUser currentUser].address;
        self.remarkTextField.text = [CCUser currentUser].remark;
        self.zfbNumTextField.text = [CCUser currentUser].alipayNum;
        self.cardNumTextField.text = [CCUser currentUser].cardNum;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CCUser * parentUser = self.registingUser?self.registingUser:[CCUser currentUser];
    if (parentUser) {
//        if (self.avatar) self.avaterImageView.image = self.avatar;
//        else [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:parentUser.headImgUrl]];
        self.comCity.text = [[parentUser.provinceName stringByAppendingString:parentUser.cityName] stringByAppendingString:parentUser.areaName];
        self.saleMarketLabel.text = parentUser.saleMarketName;
        self.saleMarketAddressLabel.text = parentUser.saleMarketAddress;
    }
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

- (IBAction)doneAction:(id)sender {
    if (self.registingUser && !self.avatar){
        [SVProgressHUD showErrorWithStatus:@"请上传头像"];
        return;
    }
    if (!(_ownerTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写厂长姓名"];
        return;
    }
    
    if (self.registingUser && (self.registingUser.provinceId == nil || self.registingUser.cityId == nil ||self.registingUser.areaId == nil)) {
        [SVProgressHUD showErrorWithStatus:@"请选择省市区"];
        return;
    }
    if (!(_comAddressTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写厂家详细地址"];
        return;
    }
    if (self.registingUser && self.registingUser.saleMarketId == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择批发市场"];
        return;
    }
    if (!(_cardNumTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写银行卡号"];
        return;
    }
    
    if (!(_zfbNumTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写支付宝号"];
        return;
    }
    if (self.registingUser) {
        self.registingUser.factoryName = _comNameTextField.text;
        self.registingUser.address = _comAddressTextField.text;
        self.registingUser.cardNum = _cardNumTextField.text;
        self.registingUser.alipayNum = _zfbNumTextField.text;
        self.registingUser.ownerName = _ownerTextField.text;
        self.registingUser.remark = _remarkTextField.text;
        [SVProgressHUD showWithStatus:@"正在注册" maskType:SVProgressHUDMaskTypeBlack];
        
        [CCFile uploadImage:[CCFile generateThumbnailOf:self.avatar withSize:320] withProgress:nil completionBlock:^(NSString *url, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"头像上传失败"];
                return ;
            } else {
                self.registingUser.headImgUrl = url;
                [CCUser signupUser:self.registingUser withBlock:^(CCUser *user, NSError *error) {
                    [SVProgressHUD dismiss];
                    if (!error) {
                        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                        UINavigationController * nav = [self.storyboard instantiateViewControllerWithIdentifier:@"SupplierNavigationController"];
                        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"注册失败"];
                    }
                }];
            }
        }];
        
        
    } else {
        
    }
    
}
- (IBAction)cityClicked:(id)sender {
    ProvinceViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProvinceViewController"];
    vc.parentUser = self.registingUser?self.registingUser:[CCUser currentUser];
    vc.profileVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)saleMarketClicked:(id)sender {
    SaleMarketViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SaleMarketViewController"];
    vc.parentUser = self.registingUser?self.registingUser:[CCUser currentUser];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)uploadAction:(id)sender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传头像"
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"从相册上传", @"拍照", nil];
    [actionSheet showInView:self.view];
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
                if ([self isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
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
    VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, (height - width)/2.0, width, width) limitScaleRatio:3.0];
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
    self.avaterImageView.image = editedImage;
    self.avatar = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
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
