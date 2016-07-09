//
//  FolloweeTableViewCell.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/23.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "FolloweeTableViewCell.h"

@implementation FolloweeTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)phoneCallAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(followeeTableViewCellPhoneCallClicked:)]) {
        [self.delegate followeeTableViewCellPhoneCallClicked:self];
    }
}

- (IBAction)enterAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(followeeTableViewCellEnterClicked:)]) {
        [self.delegate followeeTableViewCellEnterClicked:self];
    }
}

- (IBAction)cancelFollowingActon:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(followeeTableViewCellUnfollowClicked:)]) {
        [self.delegate followeeTableViewCellUnfollowClicked:self];
    }
}

@end
