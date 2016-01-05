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

@implementation PersonProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AVObject * shop = [[AVUser currentUser] objectForKey:@"shop"];
//    [shop fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
    [shop fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            self.shopNameTextField.text = [object objectForKey:@"shopName"];
            self.ownerNameTextField.text = [object objectForKey:@"shopOwnerName"];
            self.addressTextField.text = [object objectForKey:@"shopAddress"];
            AVFile * avatar = [shop objectForKey:@"shopLogo"];
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatar.url]];
            
        }
    }];
}

- (IBAction)doneAction:(id)sender {
    AVObject * shop = [[AVUser currentUser] objectForKey:@"shop"];
    [shop setObject:_shopNameTextField.text forKey:@"shopName"];
    [shop setObject:_addressTextField.text forKey:@"shopAddress"];
    [shop setObject:_ownerNameTextField.text forKey:@"shopOwnerName"];
    if (self.avatar) {
        AVFile * avatar = [AVFile fileWithData:UIImageJPEGRepresentation(self.avatar, 0.8)];
        [SVProgressHUD showWithStatus:@"正在保存" maskType:SVProgressHUDMaskTypeBlack];
        [avatar saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [shop setObject:avatar forKey:@"shopLogo"];
                [shop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                        if (self.tabBarController) {
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
                            MLTabBarViewController *tabbar = [mainStoryboard instantiateViewControllerWithIdentifier:@"SellersTabViewController"];
                            [UIApplication sharedApplication].delegate.window.rootViewController = tabbar;
                        }
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"保存失败"];
                    }
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:@"保存失败"];
            }
        }];
    } else {
        [shop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                if (self.tabBarController) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
                    MLTabBarViewController *tabbar = [mainStoryboard instantiateViewControllerWithIdentifier:@"SellersTabViewController"];
                    [UIApplication sharedApplication].delegate.window.rootViewController = tabbar;
                }
            } else {
                [SVProgressHUD showErrorWithStatus:@"保存失败"];
            }
        }];

    }
}
- (IBAction)uploadAvatarAction:(id)sender {
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
    self.avatarImageView.image = editedImage;
    self.avatar = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
