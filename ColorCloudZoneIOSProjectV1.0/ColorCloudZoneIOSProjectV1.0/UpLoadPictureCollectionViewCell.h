//
//  UpLoadPictureCollectionViewCell.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 16/4/6.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpLoadPictureCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)deleteAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
