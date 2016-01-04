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

@implementation PersonProfileViewController

- (IBAction)doneAction:(id)sender {
    [[AVUser currentUser] setObject:_ownerNameTextField.text forKey:@""];
    [[AVUser currentUser] saveInBackground];
    AVObject * shop = [[AVUser currentUser] objectForKey:@"shop"];
    [shop setObject:_shopNameTextField.text forKey:@""];
    [shop setObject:_addressTextField.text forKey:@""];
    AVFile * avatar = [AVFile fileWithData:UIImageJPEGRepresentation(_avatarImageView.image, 0.8)];
    [avatar saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [shop setObject:avatar forKey:@""];
            [shop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
                    MLTabBarViewController *tabbar = [mainStoryboard instantiateViewControllerWithIdentifier:@"SellersTabViewController"];
                    [UIApplication sharedApplication].delegate.window.rootViewController = tabbar;
                } else {
                    [SVProgressHUD showErrorWithStatus:@"保存失败"];
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
    }];
    
}
- (IBAction)uploadAvatarAction:(id)sender {
}
@end
