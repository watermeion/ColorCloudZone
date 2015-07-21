//
//  CustomSelectionBarView.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/21.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, BtnSelectedAt) {
    BtnSelectedAt_1 = 1,
    BtnSelectedAt_2 = 2,
};



@interface CustomSelectionBarView : UIView
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (strong, nonatomic) IBOutlet UIView *view;

@property (assign, nonatomic) BtnSelectedAt selectedAt;
@end
