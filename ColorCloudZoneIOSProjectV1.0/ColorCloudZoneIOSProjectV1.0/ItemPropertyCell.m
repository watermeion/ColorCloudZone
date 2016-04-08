//
//  ItemPropertyCell.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/4/8.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "ItemPropertyCell.h"

@implementation ItemPropertyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
    // Configure the view for the selected state
}

@end
