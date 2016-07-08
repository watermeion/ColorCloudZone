//
//  SupplierViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/1/3.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "SupplierViewController.h"
#import "UIImageView+WebCache.h"
#import "KxMenu.h"
#import "SVProgressHud.h"
#import "MLShopContainViewController.h"
#import "ComSettingsTableViewController.h"
#import "CCUser.h"
#import "CCFile.h"
@interface SupplierViewController ()

@end

static NSString * kMLSupplierContainerPushSegue = @"MLSupplierContainerPushSegue";

@implementation SupplierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CCUser * factory = [CCUser currentUser];
    if (self.parentUser) {
        factory = self.parentUser;
        self.navigationItem.title = factory.factoryName;
        self.uploadButton.translatesAutoresizingMaskIntoConstraints = YES;
        self.uploadButton.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
        self.uploadButton.hidden = YES;
    } else {
        //设置NavigationBar
        UIBarButtonItem *moreFeaturesLeftBarItem = [[UIBarButtonItem alloc]
                                                    initWithImage:[UIImage imageNamed:@"moreBarIcon_black.png"]
                                                    style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(moreFeaturesLeftBarAction:)];
        moreFeaturesLeftBarItem.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem = moreFeaturesLeftBarItem;
        self.navigationItem.title = @"我的市场";
    }
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width / 2.0;
    
    
    [self.coverImageView sd_setImageWithURL:[CCFile ccURLWithString:factory.coverUrl]];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CCUser * factory = [CCUser currentUser];
    self.nameLabel.text = factory.factoryName;
    [self.avatarImageView sd_setImageWithURL:[CCFile ccURLWithString:factory.headImgUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moreFeaturesLeftBarAction:(id)sender
{
    
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"更换背景"
                     image:nil
                    target:self
                    action:@selector(changeBackground:)],
      [KxMenuItem menuItem:@"我的设置"
                     image:nil
                    target:self
                    action:@selector(settingClicked:)]
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

- (IBAction)settingClicked:(id)sender
{
    ComSettingsTableViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ComSettingsTableViewController"];
    [self.navigationController pushViewController:vc animated:YES];
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
        [SVProgressHUD showWithStatus:@"正在上传..." maskType:SVProgressHUDMaskTypeBlack];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:kMLSupplierContainerPushSegue]) {
        MLShopContainViewController * vc = (MLShopContainViewController*)segue.destinationViewController;
        vc.parentVC = self;
        vc.parentUser = self.parentUser;
        self.selectionBar.delegate = vc;
    }
}


@end
