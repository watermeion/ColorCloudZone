//
//  CALayer+GYBAddtion.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by RAY on 15/8/30.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "CALayer+GYBAddtion.h"
@import UIKit;
@implementation CALayer (GYBAddtion)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
