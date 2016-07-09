//
//  UploadImagesViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 16/4/12.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "UploadImagesViewController.h"
#import "UpLoadPicBtnCollectionViewCell.h"
#import "UpLoadPictureCollectionViewCell.h"
#import "CCFile.h"
#import "SVProgressHud.h"
#import "UIImageView+WebCache.h"
@interface UploadImagesViewController ()
//@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic) NSInteger indexWillDelete;
@property (nonatomic, assign) NSInteger uploadingImageNum;
@property (nonatomic, assign) NSInteger uploadSucceedImageNum;
@property (nonatomic, assign) NSInteger uploadFailiedImageNum;
@end

@implementation UploadImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    // Do any additional setup after loading the view.
    self.title = self.displayTitle;
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        UpLoadPicBtnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUpLoadPicBtnCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    UpLoadPictureCollectionViewCell *picCell = [collectionView dequeueReusableCellWithReuseIdentifier:kUpLoadPicCellIdentifier forIndexPath:indexPath];
    
//    picCell.imageView.image = [self.selectedImages objectAtIndex:(indexPath.row - 1)];
    NSString * url = [self.currentImageArray objectAtIndex:indexPath.row - 1];
    [picCell.imageView sd_setImageWithURL:[CCFile ccURLWithString:url] placeholderImage:[self.urlPlaceholderImage objectForKey:url]];
    
    return picCell;

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return ;
    }
    self.indexWillDelete = indexPath.row - 1;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定删除该照片" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 990101;
    [alert show];
    return;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag != 990101) {
        return;
    }
    if (buttonIndex == 0) {
        self.indexWillDelete = -1;
    }else{
        if (self.indexWillDelete != -1  && self.indexWillDelete <=self.currentImageArray.count) {
            [self.urlPlaceholderImage removeObjectForKey:[self.currentImageArray objectAtIndex:self.indexWillDelete]];
            [self.currentImageArray removeObjectAtIndex:self.indexWillDelete];
        }
        self.indexWillDelete = -1;
        [self.collectionView reloadData];
    }
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1 + self.currentImageArray.count;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


#pragma mark - GBImagePicker
- (void)imagePickerBehaviorSelectedImages:(NSArray *) imageArray{
    if (imageArray.count == 0) {
        return;
    }
    self.uploadingImageNum = imageArray.count;
    self.uploadSucceedImageNum = 0;
    self.uploadFailiedImageNum = 0;
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传..共%ld张\n(成功%ld张/失败%ld张)", (long)self.uploadingImageNum, (long)self.uploadSucceedImageNum, self.uploadFailiedImageNum] maskType:SVProgressHUDMaskTypeBlack];
    for (UIImage * image in imageArray) {
        [CCFile uploadImage:image withProgress:nil completionBlock:^(NSString *url, NSError *error) {
            if (error) {
                self.uploadFailiedImageNum ++;
            } else {
                self.uploadSucceedImageNum ++;
                [self.currentImageArray addObject:url];
                [self.urlPlaceholderImage setValue:image forKey:url];
            }
            [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传..共%ld张\n(成功%ld张/失败%ld张)", (long)self.uploadingImageNum, (long)self.uploadSucceedImageNum, self.uploadFailiedImageNum] maskType:SVProgressHUDMaskTypeBlack];
            if (self.uploadSucceedImageNum + self.uploadFailiedImageNum == self.uploadingImageNum) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"上传成功%ld张，失败%ld张", (long)self.uploadSucceedImageNum, self.uploadFailiedImageNum]];
                [self.collectionView reloadData];
            }
        }];
    }
}

- (void)finishUpload
{
    
}

- (NSUInteger)limitNumSelectionforThisImagePicker{
    return self.maxImgs - self.currentImageArray.count;
}
@end
