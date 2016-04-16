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
@interface UploadImagesViewController ()
@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic) NSInteger indexWillDelete;
@end

@implementation UploadImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"qued" style:UIBarButtonItemStylePlain target:self action:@selector(doneSelected)];
    self.navigationController.navigationItem.leftBarButtonItem = done;
    self.title = self.displayTitle;
    if(self.displayImages != nil){
        self.selectedImages = [NSMutableArray arrayWithArray:self.displayImages];
    }
}


-(void)doneSelected{
    NSLog(@"准备上传");

}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        UpLoadPicBtnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUpLoadPicBtnCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    UpLoadPictureCollectionViewCell *picCell = [collectionView dequeueReusableCellWithReuseIdentifier:kUpLoadPicCellIdentifier forIndexPath:indexPath];
    
    picCell.imageView.image = [self.selectedImages objectAtIndex:(indexPath.row - 1)];
    
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
        if (self.indexWillDelete != -1  && self.indexWillDelete <=self.selectedImages.count) {
            [self.selectedImages removeObjectAtIndex:self.indexWillDelete];
        }
        self.indexWillDelete = -1;
        [self.collectionView reloadData];
    }
}


    
- (NSArray *)results{
    return [self.selectedImages copy];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1 + self.selectedImages.count;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


#pragma mark - GBImagePicker
- (void)imagePickerBehaviorSelectedImages:(NSArray *) imageArray{
    if (imageArray.count == 0) {
        return;
    }
    if ( self.selectedImages == nil){
        self.selectedImages = [NSMutableArray array];
    }
    [self.selectedImages addObjectsFromArray:imageArray];
    [self.collectionView reloadData];
}

- (NSUInteger)limitNumSelectionforThisImagePicker{
    return self.maxImgs - self.selectedImages.count;
}
@end
