//
//  LikeListCell.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/4/23.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "LikeListCell.h"

@implementation LikeListCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.avatar.layer.cornerRadius = (self.avatar.frame.size.width / 2.0);
    self.avatar.layer.masksToBounds = YES;
}
@end
