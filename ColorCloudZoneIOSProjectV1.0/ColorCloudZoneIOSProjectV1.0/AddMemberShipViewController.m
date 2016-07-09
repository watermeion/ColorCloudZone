//
//  AddMemberShipViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/16.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "AddMemberShipViewController.h"
#import "VPImageCropperViewController.h"
#import "SVProgressHud.h"
#import "CCFile.h"
#import "CCUser.h"
@interface AddMemberShipViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>

@property (nonatomic) BOOL isActiveDoneBtn;
@end

@implementation AddMemberShipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
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
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneAction:(id)sender {
    if (!(self.nameTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写会员姓名"];
        return;
    }
    
    if (!(self.phoneNumTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写会员手机号"];
        return;
    }
    
    if (!(self.addressTextField.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写会员地址"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在添加..." maskType:SVProgressHUDMaskTypeBlack];
    [CCFile uploadImage:self.avatarImageView.image withProgress:nil completionBlock:^(NSString *url, NSError *error) {
        if (!error) {
            CCMember * member = [[CCMember alloc] init];
            member.username = self.nameTextField.text;
            member.headImgUrl = url;
            member.address = self.addressTextField.text;
            member.mobile = self.phoneNumTextField.text;
            [CCUser addMember:member withBlock:^(CCMember *member, NSError *error) {
                [SVProgressHUD dismiss];
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"添加失败"];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"添加失败"];
            
        }
    }];
}










@end
