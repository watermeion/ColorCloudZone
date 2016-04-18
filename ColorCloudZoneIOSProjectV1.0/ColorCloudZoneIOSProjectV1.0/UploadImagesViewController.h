//
//  UploadImagesViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 16/4/12.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBImagePickerBehavior.h"
static NSString *kUpLoadPicBtnCellIdentifier = @"UpLoadPictureBtnCollectionViewCell";
static NSString *kUpLoadPicCellIdentifier = @"UpLoadPicCollectionViewCell";

@interface UploadImagesViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,GBImagePickerBehaviorDataTargetDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, readonly) NSArray *results;
@property (nonatomic) NSString *displayTitle;
@property (nonatomic) NSUInteger maxImgs;
@property (nonatomic, strong) NSMutableDictionary * urlPlaceholderImage;
@property (nonatomic, strong) NSMutableArray * currentImageArray;
@property (nonatomic , strong) NSArray *displayImages;
@end
