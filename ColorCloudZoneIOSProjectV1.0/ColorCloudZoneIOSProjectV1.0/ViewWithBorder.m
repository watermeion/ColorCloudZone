//
//  ViewWithBorder.m
//  FourthIOSMiniProject
//
//  Created by hzguoyubao on 15/7/30.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "ViewWithBorder.h"

@implementation ViewWithBorder


- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.borderWidth) {
        self.layer.borderWidth = self.borderWidth;
    }else{
        self.layer.borderWidth = 1;
    }

    if (self.layer.borderColor == nil) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        return;
    }
    self.layer.borderColor = self.borderColor.CGColor;

    self.layer.masksToBounds = YES;

    self.layer.cornerRadius = self.cornerRedius;
}





@end
