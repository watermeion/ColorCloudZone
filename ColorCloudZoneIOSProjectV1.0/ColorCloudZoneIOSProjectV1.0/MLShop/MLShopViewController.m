//
//  MLShopViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/17.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "MLShopViewController.h"
#import "MLShopContainViewController.h"
#import "UIImageView+WebCache.h"
#import "KxMenu.h"
#import "SVProgressHud.h"
#import "CCUser.h"
#import "CCFile.h"
static NSString *const kMLShopContainerPushSegue = @"MLShopContainerPushSegue";


@implementation MLShopViewController

- (void)viewDidLoad
{

    //设置NavigationBar
    UIBarButtonItem *moreFeaturesLeftBarItem = [[UIBarButtonItem alloc]
                                                initWithImage:[UIImage imageNamed:@"moreBarIcon_black.png"]
                                                style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(moreFeaturesLeftBarAction:)];

    moreFeaturesLeftBarItem.tintColor = [UIColor blackColor];

    UIBarButtonItem *chatFeaturesLeftBarItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chatIcon_black.png"] style:UIBarButtonItemStylePlain target:self action:@selector(chatFeaturesBarAction)];

    chatFeaturesLeftBarItem.tintColor = [UIColor blackColor];

    self.navigationItem.rightBarButtonItems = @[ moreFeaturesLeftBarItem,chatFeaturesLeftBarItem ];
    self.navigationItem.title = @"我的店铺";

    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.bounds.size.width / 2.0;
    self.nameLabel.text = [CCUser currentUser].mallName;
    [self.avatar sd_setImageWithURL:[CCFile ccURLWithString:[CCUser currentUser].headImgUrl]];
    if ([CCUser currentUser].coverUrl) [self.coverImageView sd_setImageWithURL:[CCFile ccURLWithString:[CCUser currentUser].coverUrl]];
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)moreFeaturesLeftBarAction:(id)sender
{

    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"更换背景"
                     image:nil
                    target:self
                    action:@selector(changeBackground:)],
      [KxMenuItem menuItem:@"统计"
                     image:nil
                    target:nil
                    action:NULL]
      ];
    
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:CGRectMake(self.view.frame.size.width - 44 - 10, 0, 44, 54)
                 menuItems:menuItems];
}

- (IBAction)changeBackground:(id)sender
{
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
    VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, (height - width * 14.f / 25.f)/2.0, width, width * 14.f / 25.f) limitScaleRatio:3.0];
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
        [SVProgressHUD showWithStatus:@"正在添加..." maskType:SVProgressHUDMaskTypeBlack];
        [CCFile uploadImage:editedImage withProgress:nil completionBlock:^(NSString *url, NSError *error) {
            if (error) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
            } else {
                [CCUser setUserCover:url withBlock:^(BOOL succeed, NSError *error) {
                    [SVProgressHUD dismiss];
                    if (succeed) {
                        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                        self.coverImageView.image = editedImage;
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"上传失败"];
                    }
                }];
            }
        }];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)chatFeaturesBarAction
{
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kMLShopContainerPushSegue]) {
        MLShopContainViewController * vc = (MLShopContainViewController*)segue.destinationViewController;
        vc.parentVC = self;
        self.selectionBar.delegate = vc;
    }

}

@end
