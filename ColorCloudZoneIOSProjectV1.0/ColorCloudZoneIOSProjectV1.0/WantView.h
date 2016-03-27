//
//  WantView.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/23.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WantView;
@protocol WantViewDelegate <NSObject>

- (void)wantViewOKButtonClicked:(WantView *)view;
- (void)wantViewDidDismiss:(WantView *)view;
@end
@interface WantView : UIView
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UITextField *userIdLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;

@property (weak, nonatomic) id<WantViewDelegate> delegate;
@property (strong, nonatomic) UIView * maskView;

- (void)showInView:(UIView *)view;
@end
