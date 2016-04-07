//
//  PersonProfileViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/3.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "PersonProfileViewController.h"
#import "MLTabBarViewController.h"
#import "SVProgressHud.h"
#import "UIImageView+WebCache.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "ProvinceViewController.h"
#import "SaleMarketViewController.h"
#import "CCFile.h"
@implementation PersonProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([CCUser currentUser]) {
        
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[CCUser currentUser].headImgUrl]];
        self.shopNameTextField.text = [CCUser currentUser].mallName;
        self.ownerNameTextField.text = [CCUser currentUser].ownerName;
        self.addressTextField.text = [CCUser currentUser].address;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CCUser * parentUser = self.registingUser?self.registingUser:[CCUser currentUser];
    if (parentUser) {
        self.cityTextField.text = [NSString stringWithFormat:@"%@%@%@", parentUser.provinceName?parentUser.provinceName:@"", parentUser.cityName?parentUser.cityName:@"", parentUser.areaName?parentUser.areaName:@""];
        self.saleMarketNameLabel.text = parentUser.saleMarketName;
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

- (IBAction)doneAction:(id)sender {
    if (self.registingUser && !self.avatar){
        [SVProgressHUD showErrorWithStatus:@"请上传头像"];
        return;
    }
    if (!(self.shopNameTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写店铺名称"];
        return;
    }
    if (!(self.ownerNameTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写店主姓名"];
        return;
    }
    if (self.registingUser && (self.registingUser.provinceId == nil || self.registingUser.cityId == nil ||self.registingUser.areaId == nil)) {
        [SVProgressHUD showErrorWithStatus:@"请选择省市区"];
        return;
    }
    if (!(self.addressTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写详细地址"];
        return;
    }
    if (self.registingUser && self.registingUser.saleMarketId == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择批发市场"];
        return;
    }
    if (self.registingUser) {
        self.registingUser.mallName = self.shopNameTextField.text;
        self.registingUser.ownerName = self.ownerNameTextField.text;
        self.registingUser.address = self.addressTextField.text;
        [SVProgressHUD showWithStatus:@"正在注册"];
        [CCFile uploadImage:self.avatar withProgress:nil completionBlock:^(NSString *url, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"头像上传失败"];
                return ;
            } else {
                self.registingUser.headImgUrl = url;
                [CCUser signupUser:self.registingUser withBlock:^(CCUser *user, NSError *error) {
                    [SVProgressHUD dismiss];
                    if (!error) {
                        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                        MLTabBarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"SellersTabViewController"];
                        [UIApplication sharedApplication].delegate.window.rootViewController = tabbar;
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"注册失败"];
                    }
                }];
            }
        }];
    } else {
        
    }
    
}
- (IBAction)uploadAvatarAction:(id)sender {
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
    self.avatarImageView.image = editedImage;
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
