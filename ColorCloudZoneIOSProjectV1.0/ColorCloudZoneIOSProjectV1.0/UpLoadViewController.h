//
//  UpLoadViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 16/3/29.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBTableViewSelectorBehavior.h"
@interface UpLoadViewController : UIViewController

@property (nonatomic) IBOutlet UITextField *itemName;
@property (nonatomic) IBOutlet UITextField *itemSerialNum;
@property (nonatomic) IBOutlet UITextField *itemWholeSalePrice;
@property (nonatomic) IBOutlet UICollectionView *itemPicCollectionView;
@property (nonatomic) IBOutlet UIButton *itemCategoryBtn;
@property (nonatomic, strong) NSMutableDictionary * urlPlaceholderImage;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
- (IBAction)chooseColorAction:(id)sender;

- (IBAction)chooseSurfaceAction:(id)sender;


- (IBAction)chooseCategoryAction:(id)sender;


@property (nonatomic) IBOutlet UITextView *itemDetailInputView;
@property (nonatomic) IBOutlet UILabel *surfaceMater;
@property (nonatomic) IBOutlet UILabel *categoryLabel;

@property (nonatomic) NSString *itemCategory;
@property (nonatomic) NSString *itemMaterial;
@property (nonatomic) NSString *itemSurfaceMaterial;
@property (nonatomic) NSArray *itemImagesArray;

//Property
@property (nonatomic,readonly) NSInteger pictureNum;



@end
