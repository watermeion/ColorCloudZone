//
//  CustomSelectionBarView.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/21.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "CustomSelectionBarView.h"

@interface CustomSelectionBarView ()
@property (weak, nonatomic) IBOutlet UIView *buttomView;
- (IBAction)btn1Action:(id)sender;
- (IBAction)btn2Action:(id)sender;

@end

@implementation CustomSelectionBarView


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //初始化选择
        _selectedAt = BtnSelectedAt_1;
    }
    return self;

}

- (void)awakeFromNib
{
    [[NSBundle mainBundle] loadNibNamed:@"CustomSelectionBarView" owner:self options:nil];
    [self addSubview:self.view];
    if (self.delegate && [self.delegate respondsToSelector:@selector(button1Title)]) {
        [self.button1 setTitle:[self.delegate button1Title] forState:UIControlStateNormal];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(button2Title)]) {
        [self.button2 setTitle:[self.delegate button2Title] forState:UIControlStateNormal];
    }

}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

///**
// *  overrided selectAt setter Method
// *
// *  @param status <#status description#>
// */
//- (void)selectedAt:(BtnSelectedAt) status
//{
//    _selectedAt=status;
////TODO:可以做一些通知操作
//
//}


- (IBAction)btn1Action:(id)sender
{
    if (self.selectedAt == BtnSelectedAt_1) {
        return;
    }
    self.selectedAt = BtnSelectedAt_1;

    [self changeButtonViewPositionWithAnnimation:BtnSelectedAt_1];
    if (self.delegate && [self.delegate respondsToSelector:@selector(btn1Selected:)]) {
        [self.delegate btn1Selected:self];
    }
}

- (IBAction)btn2Action:(id)sender
{
    if (self.selectedAt==BtnSelectedAt_2) {
        return;
    }
    self.selectedAt = BtnSelectedAt_2;

    [self changeButtonViewPositionWithAnnimation:BtnSelectedAt_2];
    if (self.delegate && [self.delegate respondsToSelector:@selector(btn2Selected:)]) {
        [self.delegate btn2Selected:self];
    }

}


- (void)changeButtonViewPositionWithAnnimation:(BtnSelectedAt)newSelectAt
{
    if (self.buttomView == nil) {
        return;
    }

    switch (newSelectAt) {
        case BtnSelectedAt_1:
            //
            self.buttomView.center = CGPointMake(self.button1.center.x, self.buttomView.center.y);

            //            newframe=CGRectMake(self.buttomView.frame.origin.x, self.buttomView.frame.origin.y, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
            break;

        case BtnSelectedAt_2:
            self.buttomView.center = CGPointMake(self.button2.center.x, self.buttomView.center.y);            break;
    }

    //    self.buttomView.transform = CGAffineTransformIdentity;
    //
    //
    //    [UIView beginAnimations:@"Move"context:self.buttomView];
    //
    //    [UIView setAnimationDelegate:self];
    //
    ////    [UIView setAnimationDidStopSelector:@selector(enablebutton)];
    //    self.buttomView.frame=newframe;
    ////    imageView.frame=CGRectMake(34, 0, 320, 320);
    //
    //    [UIView commitAnimations];
    [self setNeedsDisplay];
    
}


@end
