//
//  CollectAlertView.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/1/8.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "CollectAlertView.h"

@implementation CollectAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)collectClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectAlertViewCollectButtonClicked:)]) {
        [self.delegate collectAlertViewCollectButtonClicked:self];
    }
}

- (void)showInView:(UIView *)view
{
    self.maskView = [[UIView alloc] initWithFrame:view.frame];
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.maskView.alpha = 0;
    [view addSubview:self.maskView];
    [view addSubview:self];
    self.frame = CGRectZero;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake((view.frame.size.width - 320)/2.f, (view.frame.size.height - 320)/2.f, 320, 320);
        self.maskView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            self.frame = CGRectMake((view.frame.size.width - 300)/2.f, (view.frame.size.height - 300)/2.f, 300, 300);
        } completion:nil];
    }];
}
@end
