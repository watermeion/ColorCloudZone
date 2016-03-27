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
@interface CompanyProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>

@end

@implementation CompanyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    if (_comNameTextField.text.length * _comAddressTextField.text.length * _cardNumTextField.text.length * _zfbNumTextField.text.length * _ownerTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请将信息填写完整"];
        return;
    }
    
    if (self.registingUser) {
        self.registingUser.factoryName = _comNameTextField.text;
        self.registingUser.address = _comAddressTextField.text;
        self.registingUser.cardId = _cardNumTextField.text;
        self.registingUser.alipayId = _zfbNumTextField.text;
        self.registingUser.ownerName = _ownerTextField.text;
        
        [SVProgressHUD showWithStatus:@"正在注册" maskType:SVProgressHUDMaskTypeBlack];
        [CCUser signupUser:self.registingUser withBlock:^(CCUser *user, NSError *error) {
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                UINavigationController * nav = [self.storyboard instantiateViewControllerWithIdentifier:@"SupplierNavigationController"];
                [UIApplication sharedApplication].delegate.window.rootViewController = nav;
            } else {
                [SVProgressHUD showErrorWithStatus:@"注册失败"];
            }

        }];
    } else {
        
    }
    
}
- (IBAction)uploadAction:(id)sender {
    UIImagePickerController * vc = [[UIImagePickerController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
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
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
