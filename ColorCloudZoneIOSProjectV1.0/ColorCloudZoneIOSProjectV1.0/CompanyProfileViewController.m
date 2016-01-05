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
    
    [SVProgressHUD showWithStatus:@"正在保存" maskType:SVProgressHUDMaskTypeBlack];
    AVObject * manufacture = [[AVUser currentUser] objectForKey:@"manufacture"];
    [manufacture setObject:_comNameTextField.text forKey:@"name"];
    [manufacture setObject:_comAddressTextField.text forKey:@"address"];
    [manufacture setObject:_cardNumTextField.text forKey:@"card"];
    [manufacture setObject:_zfbNumTextField.text forKey:@"zhifubao"];
    [manufacture setObject:_ownerTextField.text forKey:@"ownerName"];
    AVFile * avatar = [AVFile fileWithData:UIImageJPEGRepresentation(_avaterImageView.image, 0.8)];
    [avatar saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [manufacture setObject:avatar forKey:@"avatar"];
            [manufacture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                    UINavigationController * nav = [self.storyboard instantiateViewControllerWithIdentifier:@"SupplierNavigationController"];
                    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
                } else {
                    [SVProgressHUD showErrorWithStatus:@"保存失败"];
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
    }];
    
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
