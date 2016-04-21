//
//  WantView.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/23.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "WantView.h"
#import "ItemPropertyCell.h"

#import "SVProgressHud.h"

@implementation WantView 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.selectedColor = [NSMutableArray array];
//    self.selectedSize = [NSMutableArray array];
}

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
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.maskView addGestureRecognizer:recognizer];
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
    if (!(self.userIdLabel.text.length > 0)) {
        [SVProgressHUD showErrorWithStatus:@"请填写会员手机号"];
        return;
    }
    
    if (!self.selectedColor) {
        [SVProgressHUD showErrorWithStatus:@"请选择想要的颜色"];
        return;
    }
    if (!self.selectedSize) {
        [SVProgressHUD showErrorWithStatus:@"请选择想要的尺寸"];
        return;
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wantViewOKButtonClicked:)]) {
        [self.delegate wantViewOKButtonClicked:self];
    }
    [self dismiss];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.parentItem.colorProperty.count;
    } else {
        return self.parentItem.sizeProperty.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"请选择颜色";
    } else {
        return @"请选择尺寸";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PropertyCell"];
    CCItemPropertyValue * prop;
    if (indexPath.section == 0) {
        prop = [self.parentItem.colorProperty objectAtIndex:indexPath.row];
        if (prop == self.selectedColor) [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        else [cell setAccessoryType:UITableViewCellAccessoryNone];
    } else {
        prop = [self.parentItem.sizeProperty objectAtIndex:indexPath.row];
        if (prop == self.selectedSize) [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        else [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    cell.textLabel.text = prop.value;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCItemPropertyValue * property;
    if (indexPath.section == 0) {
        property = [self.parentItem.colorProperty objectAtIndex:indexPath.row];
//        for (CCItemPropertyValue * prop in self.selectedColor)
//            if ([prop.valueId isEqualToString:property.valueId]) return;
//        [self.selectedColor addObject:property];
        self.selectedColor = property;
        
    } else {
        property = [self.parentItem.sizeProperty objectAtIndex:indexPath.row];
//        for (CCItemPropertyValue * prop in self.selectedSize)
//            if ([prop.valueId isEqualToString:property.valueId]) return;
//        [self.selectedSize addObject:property];
        self.selectedSize = property;
    }
    [self.tableView reloadData];
}
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CCItemPropertyValue * property;
//    if (indexPath.section == 0) {
//        property = [self.parentItem.colorProperty objectAtIndex:indexPath.row];
////        CCItemPropertyValue * propToDelete;
////        for (CCItemPropertyValue * prop in self.selectedColor)
////            if ([prop.valueId isEqualToString:property.valueId]) {
////                propToDelete = prop;
////                break;
////            }
////        if (propToDelete) [self.selectedColor removeObject:propToDelete];
//        if (property == self.selectedColor) {
//            self.selectedColor = nil;
//        }
//    } else {
//        property = [self.parentItem.sizeProperty objectAtIndex:indexPath.row];
////        CCItemPropertyValue * propToDelete;
////        for (CCItemPropertyValue * prop in self.selectedSize)
////            if ([prop.valueId isEqualToString:property.valueId]) {
////                propToDelete = prop;
////                break;
////            }
////        if (propToDelete) [self.selectedSize removeObject:propToDelete];
//        if (property == self.selectedSize) {
//            self.selectedSize = nil;
//        }
//    }
//    
//}
@end
