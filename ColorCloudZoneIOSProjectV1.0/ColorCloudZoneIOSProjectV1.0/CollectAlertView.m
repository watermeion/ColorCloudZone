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
    UIView * superView = [self superview];
    [UIView animateWithDuration:0.05 animations:^{
        self.frame = CGRectMake((superView.frame.size.width - 300)/2.f, (superView.frame.size.height - 300)/2.f - 20, 300, 300);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake((superView.frame.size.width - 300)/2.f, superView.frame.size.height, 300, 300);
            self.maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }];
}

- (void)showInView:(UIView *)view
{
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.maskView.alpha = 0;
    [view.window addSubview:self.maskView];
    [view.window addSubview:self];
    self.frame = CGRectMake((view.frame.size.width - 300)/2.f, view.frame.size.height, 300, 300);
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake((view.frame.size.width - 300)/2.f, (view.frame.size.height - 300)/2.f - 20, 300, 300);
        self.maskView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            self.frame = CGRectMake((view.frame.size.width - 300)/2.f, (view.frame.size.height - 300)/2.f, 300, 300);
        } completion:nil];
    }];
}
@end
