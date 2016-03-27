//
//  WantView.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/23.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "WantView.h"

@implementation WantView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dismiss
{
    
    UIView * view = [self superview];
    [UIView animateWithDuration:0.08 animations:^{
        self.frame = CGRectMake(0, view.frame.origin.y + view.frame.size.height - 450, view.frame.size.width, 430);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(0, view.frame.origin.y + view.frame.size.height, view.frame.size.width, 430);
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
    self.frame = CGRectMake(0, view.frame.origin.y + view.frame.size.height, view.frame.size.width, 430);
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(0, view.frame.origin.y + view.frame.size.height - 450, view.frame.size.width, 430);
        self.maskView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08 animations:^{
            self.frame = CGRectMake(0, view.frame.origin.y + view.frame.size.height - 430, view.frame.size.width, 430);
        } completion:nil];
    }];
}


- (IBAction)wantClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wantViewOKButtonClicked:)]) {
        [self.delegate wantViewOKButtonClicked:self];
    }
    [self dismiss];
}
@end
