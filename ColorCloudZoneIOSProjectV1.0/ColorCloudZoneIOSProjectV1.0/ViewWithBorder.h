//
//  ViewWithBorder.h
//  FourthIOSMiniProject
//
//  Created by hzguoyubao on 15/7/30.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewWithBorder : UIView

@property (assign, nonatomic) IBInspectable float borderWidth;

@property (strong, nonatomic) IBInspectable UIColor *borderColor;

@property (assign, nonatomic) IBInspectable NSUInteger cornerRedius;

@end
