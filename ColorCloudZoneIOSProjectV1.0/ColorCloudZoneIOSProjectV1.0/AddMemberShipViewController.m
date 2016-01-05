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
#import "AVObjectKeys.h"
@interface AddMemberShipViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>

@property (nonatomic) BOOL isActiveDoneBtn;
@end

@implementation AddMemberShipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
//    var realname = request.params.MemeberName;
//    var mobile = request.params.MemberMobile;
//    var avatar = request.params.MemberLogoUrl;
//    var shopId = request.params.shopId;
//    var memberAddress = request.params.MemberAddress;
    [SVProgressHUD showWithStatus:@"正在添加..." maskType:SVProgressHUDMaskTypeBlack];
    AVFile * file = [AVFile fileWithData:UIImageJPEGRepresentation(self.avatarImageView.image, 0.8)];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            AVObject * shopMember = [AVObject objectWithClassName:@"ShopMember"];
            [shopMember setObject:self.nameTextField.text forKey:ShopMemberNameKey];
            [shopMember setObject:self.phoneNumTextField.text forKey:ShopMemberMobileKey];
            [shopMember setObject:self.addressTextField.text forKey:ShopMemberAddressKey];
            [shopMember setObject:file forKey:ShopMemberLogoUrlKey];
            [shopMember saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"添加失败"];
                } else {
                    AVObject * shop = [[AVUser currentUser] objectForKey:@"shop"];
                    AVRelation * shopMembers = [shop relationforKey:@"shopMember"];
                    [shopMembers addObject:shopMember];
                    [shop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error) {
                            [SVProgressHUD showErrorWithStatus:@"添加失败"];
                        } else {
                            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"添加失败"];
        }
    }];
}










@end
