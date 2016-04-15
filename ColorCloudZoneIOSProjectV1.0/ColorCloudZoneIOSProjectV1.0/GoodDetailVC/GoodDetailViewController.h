//
//  GoodDetailViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/5.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBCustomViewController.h"
#import "CCItem.h"
#import "CCUser.h"
#import "CCFile.h"

@interface GoodDetailViewController : GBCustomViewController
@property (nonatomic, strong) CCItem * parentItem;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *factoryName;
@property (strong, nonatomic) IBOutlet UILabel *itemSNLabel;
@property (strong, nonatomic) IBOutlet UIImageView *factoryAvatar;
@property (strong, nonatomic) IBOutlet UILabel *factoryPhone;
@property (strong, nonatomic) IBOutlet UILabel *factoryProductCount;
@property (strong, nonatomic) IBOutlet UILabel *factoryNewCount;
@property (strong, nonatomic) IBOutlet UILabel *materialLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *collectButton;
@property (strong, nonatomic) UIViewController * parentVC;
//Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTextHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *contactAndCollectView;

@property (strong, nonatomic) IBOutlet UIView *wantView;




@end
