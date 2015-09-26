//
//  RecommendItemsCollectionViewCell.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/9/26.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendItemsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
