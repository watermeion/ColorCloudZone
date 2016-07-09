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
@class CustomSelectionBarView;

@protocol CustomSelectionBarViewDelegate <NSObject>

- (void) btn1Selected:(CustomSelectionBarView*)view;
- (void) btn2Selected:(CustomSelectionBarView*)view;
@optional
- (NSString *)button1Title;
- (NSString *)button2Title;

@end

@interface CustomSelectionBarView : UIView

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) id<CustomSelectionBarViewDelegate> delegate;
@property (assign, nonatomic) BtnSelectedAt selectedAt;

- (void)reloadTitle;
@end
