//
//  ShopListTableViewCell.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/27.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *leftDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftInfoLabel;




@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLikeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightHeartImageView;




@end
