//
//  CollectAlertView.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/1/8.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectAlertView;

@protocol CollectAlertViewDelegate <NSObject>

- (void)collectAlertViewCollectButtonClicked:(CollectAlertView *)view;
- (void)collectAlertViewDidDismiss:(CollectAlertView *)view;
@end

@interface CollectAlertView : UIView
@property (strong, nonatomic) IBOutlet UILabel *inPrice;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *outPrice;
@property (strong, nonatomic) IBOutlet UILabel *SNLabel;
@property (weak, nonatomic) id<CollectAlertViewDelegate> delegate;
@property (strong, nonatomic) UIView * maskView;
- (void)showInView:(UIView *)view;

@end
