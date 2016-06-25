
//
//  GoodDetailViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/5.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "RecommendItemsCollectionViewCell.h"
#import "MoreItemsCollectionViewCell.h"
#import "DetailImageCollectionViewController.h"
#import "UIImageView+WebCache.h"
#import "MarketViewController.h"
#import "MLShopViewController.h"
#import "SupplierViewController.h"
#import "KxMenu.h"
#import "CollectAlertView.h"
#import "WantView.h"
#import "SVProgressHud.h"
#import "DCPicScrollView.h"
#import "DCWebImageManager.h"
#import "LikeListCell.h"
#import "MallItemStatisticsViewController.h"
#import "FactoryItemStatisticsViewController.h"


#define DescPictureOriginY 66
#define DescPictureScale 0.75
#define DescPictureHeight ([UIScreen mainScreen].bounds.size.width / DescPictureScale)
#define ViewSeparatorHeight 8
#define TagsPadding 15
#define HeightOfLine 35
#define Space 10
#define TagHorizontalPadding 4
#define TagVerticalPadding 2

static  NSString *recommendCellIdentifier = @"RecommendItemsCollectionViewCell";
static  NSString *moreCellIdentifier = @"MoreItemsCollectionViewCell";

static const NSInteger kQueryLimit = 50;



@interface GoodDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, CollectAlertViewDelegate, WantViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray * menuItems;
@property (strong, nonatomic) NSMutableArray * likeList;
@property (strong, nonatomic) CCUser * factory;


@end

@implementation GoodDetailViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = YES;
    self.headView.translatesAutoresizingMaskIntoConstraints = YES;
    self.titleView.translatesAutoresizingMaskIntoConstraints = YES;
    self.propertyView.translatesAutoresizingMaskIntoConstraints = YES;
    self.factoryView.translatesAutoresizingMaskIntoConstraints = YES;
    self.likeListView.translatesAutoresizingMaskIntoConstraints = YES;
    self.descImagesView.translatesAutoresizingMaskIntoConstraints = YES;
    self.scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    
    
    _likeLabel.text = [NSString stringWithFormat:@"%ld人喜欢", (long)self.parentItem.likeNum];
    _titleLabel.text = self.parentItem.name;
    _itemSNLabel.text = [@"货号:" stringByAppendingString:self.parentItem.SN];
    _priceLabel.text = [@"￥" stringByAppendingString:[NSNumber numberWithFloat:self.parentItem.price].stringValue];
    [self setDescImages];
    [self setBannerView];
    
    // Do any additional setup after loading the view.
    if ([self.parentVC isKindOfClass:[MLShopViewController class]]) {
        self.wantView.hidden = NO;
        self.contactAndCollectView.hidden = YES;
        _menuItems = @[[KxMenuItem menuItem:@"取消收藏"
                                      image:nil
                                     target:self
                                     action:@selector(uncollect:)],
                       [KxMenuItem menuItem:@"统计"
                                      image:nil
                                     target:self
                                     action:@selector(mallItemStatistics:)]];
        //厂家View不显示，想要CollectionView显示
        [self.factoryView removeFromSuperview];
        _likeListTitle.text = [NSString stringWithFormat:@"  %ld人喜欢", (long)self.parentItem.likeNum];
        [CCItem getItemLikeList:self.parentItem limit:kQueryLimit skip:0 withBlock:^(NSArray *memberList, NSError *error) {
            if (error) {
                
            } else {
                self.likeList = [NSMutableArray arrayWithArray:memberList];
                [self.collectionView reloadData];
            }
        }];
    } else if ([self.parentVC isKindOfClass:[MarketViewController class]]) {
        self.wantView.hidden = YES;
        self.contactAndCollectView.hidden = NO;
        [self.collectButton setTitle:self.parentItem.isCollected?@"已收藏":@"收藏" forState:UIControlStateNormal];
        //厂家View显示，想要CollectionView不显示
        [self.likeListView removeFromSuperview];
        
        [CCItem getItemFactory:self.parentItem withBlock:^(CCUser *factory, NSError *error) {
            if (error) {
                
            } else {
                self.factory = factory;
                self.factoryName.text = factory.factoryName;
                self.factoryPhone.text = factory.mobile;
                [self.factoryAvatar sd_setImageWithURL:[CCFile ccURLWithString:factory.headImgUrl]];
                self.factoryNewCount.text = [NSNumber numberWithInteger:factory.newNum].stringValue;
                self.factoryProductCount.text = [NSNumber numberWithInteger:factory.totalNum].stringValue;
            }
        }];
    } else {
        self.wantView.hidden = YES;
        self.contactAndCollectView.hidden = YES;
        _menuItems = @[[KxMenuItem menuItem:@"编辑"
                                      image:nil
                                     target:nil
                                     action:NULL],
                       [KxMenuItem menuItem:@"下架"
                                      image:nil
                                     target:self
                                     action:@selector(unsell:)],
                       [KxMenuItem menuItem:@"统计"
                                      image:nil
                                     target:self
                                     action:@selector(factoryItemStatistics:)]];
        //厂家View和想要CollectionView都不显示
        [self.factoryView removeFromSuperview];
        [self.likeListView removeFromSuperview];
    }
    if (_menuItems) {
        UIBarButtonItem *moreFeaturesLeftBarItem = [[UIBarButtonItem alloc]
                                                    initWithImage:[UIImage imageNamed:@"moreBarIcon_black"]
                                                    style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(moreFeaturesLeftBarAction:)];
        moreFeaturesLeftBarItem.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem = moreFeaturesLeftBarItem;
    }
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [SVProgressHUD showWithStatus:@"正在获取信息" maskType:SVProgressHUDMaskTypeBlack];
    [CCItem getItemDetailInfo:self.parentItem withBlock:^(CCItem *item, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        } else {
            _materialLabel.text = [@"面料: " stringByAppendingString:self.parentItem.extendProperty.value];
            _descLabel.text = (self.parentItem.desc.length > 0)?self.parentItem.desc:@"没有填写详细描述。没有填写详细描述。没有填写详细描述。没有填写详细描述。没有填写详细描述。";
            [self setPropertyViewContent];
        }
    }];
    
    
    
//    self.scrollView.layer.borderColor = [UIColor blackColor].CGColor;
//    self.scrollView.layer.borderWidth = 1.f;
//    self.headView.layer.borderColor = [UIColor redColor].CGColor;
//    self.headView.layer.borderWidth = 1.f;
//    self.titleView.layer.borderColor = [UIColor orangeColor].CGColor;
//    self.titleView.layer.borderWidth = 1.f;
//    self.propertyView.layer.borderColor = [UIColor yellowColor].CGColor;
//    self.propertyView.layer.borderWidth = 1.f;
//    self.factoryView.layer.borderColor = [UIColor greenColor].CGColor;
//    self.factoryView.layer.borderWidth = 1.f;
//    self.likeListView.layer.borderColor = [UIColor blueColor].CGColor;
//    self.likeListView.layer.borderWidth = 1.f;
//    self.descImagesView.layer.borderColor = [UIColor purpleColor].CGColor;
//    self.descImagesView.layer.borderWidth = 1.f;
}

- (void)setDescImages
{
    for (NSInteger index = 0; index < self.parentItem.descPics.count; index ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, DescPictureOriginY + index * DescPictureHeight, self.view.frame.size.width, DescPictureHeight)];
        [imageView sd_setImageWithURL:[CCFile ccURLWithString:[self.parentItem.descPics objectAtIndex:index]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.descImagesView addSubview:imageView];
    }
}

- (void)setPropertyViewContent
{
    UILabel * colorTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 132, 38)];
    colorTitle.backgroundColor = [UIColor colorWithRed:1 green:191.f/255.f blue:0 alpha:1];
    colorTitle.font = [UIFont systemFontOfSize:18];
    colorTitle.textColor = [UIColor blackColor];
    colorTitle.text = @"  可选择的颜色";
    [self.propertyView addSubview:colorTitle];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width - TagsPadding;
    NSInteger line = 0;
    CGFloat curX = width;
    CGFloat orginY = colorTitle.frame.origin.y + colorTitle.frame.size.height + 14;
    for (CCItemPropertyValue * property in self.parentItem.colorProperty) {
        NSString * name = property.value;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0]};
        CGRect rect = [name boundingRectWithSize:CGSizeMake(width, HeightOfLine) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGRect frame;
        if (curX + Space + TagHorizontalPadding * 2 + rect.size.width <= width) {
            frame = CGRectMake(curX + Space, orginY + (line - 1) * HeightOfLine + (HeightOfLine - rect.size.height - TagVerticalPadding * 2) / 2.0, rect.size.width + TagHorizontalPadding * 2, rect.size.height + TagVerticalPadding * 2);
            curX += (Space + TagHorizontalPadding * 2 + rect.size.width);
        }
        else {
            line ++;
            frame = CGRectMake(TagsPadding, orginY + (line - 1) * HeightOfLine + (HeightOfLine - rect.size.height - TagVerticalPadding * 2) / 2.0, rect.size.width + TagHorizontalPadding * 2, rect.size.height + TagVerticalPadding * 2);
            curX = TagsPadding  + TagHorizontalPadding * 2 + rect.size.width;
        }
        UILabel * label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        label.text = name;
        label.font = [UIFont systemFontOfSize:18.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.layer.cornerRadius = 6.f;
        label.layer.masksToBounds = YES;
        [self.propertyView addSubview:label];
    }
    
    
    UILabel * sizeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, orginY + line * HeightOfLine + 14, 132, 38)];
    sizeTitle.backgroundColor = [UIColor colorWithRed:1 green:191.f/255.f blue:0 alpha:1];
    sizeTitle.font = [UIFont systemFontOfSize:18];
    sizeTitle.textColor = [UIColor blackColor];
    sizeTitle.text = @"  可选择的尺寸";
    [self.propertyView addSubview:sizeTitle];
    
    line = 0;
    curX = width;
    orginY = sizeTitle.frame.origin.y + sizeTitle.frame.size.height + 14;
    for (CCItemPropertyValue * property in self.parentItem.sizeProperty) {
        NSString * name = property.value;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0]};
        CGRect rect = [name boundingRectWithSize:CGSizeMake(width, HeightOfLine) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGRect frame;
        if (curX + Space + TagHorizontalPadding * 2 + rect.size.width <= width) {
            frame = CGRectMake(curX + Space, orginY + (line - 1) * HeightOfLine + (HeightOfLine - rect.size.height - TagVerticalPadding * 2) / 2.0, rect.size.width + TagHorizontalPadding * 2, rect.size.height + TagVerticalPadding * 2);
            curX += (Space + TagHorizontalPadding * 2 + rect.size.width);
        }
        else {
            line ++;
            frame = CGRectMake(TagsPadding, orginY + (line - 1) * HeightOfLine + (HeightOfLine - rect.size.height - TagVerticalPadding * 2) / 2.0, rect.size.width + TagHorizontalPadding * 2, rect.size.height + TagVerticalPadding * 2);
            curX = TagsPadding  + TagHorizontalPadding * 2 + rect.size.width;
        }
        UILabel * label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        label.text = name;
        label.font = [UIFont systemFontOfSize:18.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.layer.cornerRadius = 6.f;
        label.layer.masksToBounds = YES;
        [self.propertyView addSubview:label];
    }
    self.propertyView.frame = CGRectMake(0, self.titleView.frame.origin.y + self.titleView.frame.size.height + ViewSeparatorHeight, self.scrollView.frame.size.width, orginY + line * HeightOfLine + 14);
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat scrollViewHeight = self.view.frame.size.height - self.scrollView.frame.origin.y;
    if (!self.wantView.hidden || !self.contactAndCollectView.hidden) {
        scrollViewHeight = self.view.frame.size.height - self.scrollView.frame.origin.y - self.wantView.frame.size.height;
    }
    self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, scrollViewHeight);
    self.headView.frame = CGRectMake(0, 254, self.scrollView.frame.size.width, self.headView.frame.size.height);
    self.titleView.frame = CGRectMake(0, self.headView.frame.origin.y + self.headView.frame.size.height + 1, self.scrollView.frame.size.width, self.titleView.frame.size.height);
    self.propertyView.frame = CGRectMake(0, self.titleView.frame.origin.y + self.titleView.frame.size.height + ViewSeparatorHeight, self.scrollView.frame.size.width, self.propertyView.frame.size.height);
    if (self.factoryView.superview == self.scrollView) {
        self.factoryView.frame = CGRectMake(0, self.propertyView.frame.origin.y + self.propertyView.frame.size.height + ViewSeparatorHeight, self.scrollView.frame.size.width, self.factoryView.frame.size.height);
        self.descImagesView.frame = CGRectMake(0, self.factoryView.frame.origin.y + self.factoryView.frame.size.height + ViewSeparatorHeight, self.view.frame.size.width, DescPictureOriginY + self.parentItem.descPics.count * DescPictureHeight);
    } else {
        if (self.likeListView.superview == self.scrollView) {
            self.likeListView.frame = CGRectMake(0, self.propertyView.frame.origin.y + self.propertyView.frame.size.height + ViewSeparatorHeight, self.view.frame.size.width, self.likeListView.frame.size.height);
            self.descImagesView.frame = CGRectMake(0, self.likeListView.frame.origin.y + self.likeListView.frame.size.height + ViewSeparatorHeight, self.view.frame.size.width, DescPictureOriginY + self.parentItem.descPics.count * DescPictureHeight);
            
        } else {
            self.descImagesView.frame = CGRectMake(0, self.propertyView.frame.origin.y + self.propertyView.frame.size.height + ViewSeparatorHeight, self.view.frame.size.width, DescPictureOriginY + self.parentItem.descPics.count * DescPictureHeight);
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.descImagesView.frame.origin.y + self.descImagesView.frame.size.height);
}


- (void)setBannerView
{
    if (self.parentItem.assistantPics.count < 2) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 254)];
        [imageView sd_setImageWithURL:[CCFile ccURLWithString:[self.parentItem.assistantPics firstObject]]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [self.scrollView addSubview:imageView];
        return;
    }
    NSMutableArray *UrlStringArray = [NSMutableArray array];
//    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSString * url in self.parentItem.assistantPics) {
        [UrlStringArray addObject:[CCFile ccURLWithString:url].absoluteString];
    }
    
    DCPicScrollView  *picView = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 254) WithImageUrls:UrlStringArray];
    picView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:picView];
    
    //显示顺序和数组顺序一致
    //设置标题显示文本数组
    
    picView.style = PageControlAtCenter;
    
    //            picView.titleData = titleArray;
    
    //占位图片,你可以在下载图片失败处修改占位图片
    picView.placeImage = [UIImage imageNamed:@"uialq.jpg"];
    
    //图片被点击事件,当前第几张图片被点击了,和数组顺序一致
    [picView setImageViewDidTapAtIndex:^(NSInteger index) {
        printf("第%zd张图片\n",index);
    }];
    
    //default is 2.0f,如果小于0.5不自动播放
    picView.AutoScrollDelay = 5.0f;
    //    picView.textColor = [UIColor redColor];
    //下载失败重复下载次数,默认不重复,
    [[DCWebImageManager shareManager] setDownloadImageRepeatCount:1];
    //图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
    //error错误信息
    //url下载失败的imageurl
    [[DCWebImageManager shareManager] setDownLoadImageError:^(NSError *error, NSString *url) {
        NSLog(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moreFeaturesLeftBarAction:(id)sender
{
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:CGRectMake(self.view.frame.size.width - 44 - 10, 0, 44, 54)
                 menuItems:_menuItems];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)followClicked:(id)sender {
    [SVProgressHUD showWithStatus:@"正在关注" maskType:SVProgressHUDMaskTypeBlack];
    [CCUser follow:YES factory:self.parentItem.factoryId withBlock:^(BOOL success, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"关注失败"];
        } else {
            if (success) {
                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"关注失败"];
            }
        }
    }];
}


- (IBAction)enterFactoryClicked:(id)sender {
    SupplierViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SupplierViewController"];
    vc.parentUser = self.factory;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)callFactoryClicked:(id)sender {
    NSString * str=[NSString stringWithFormat:@"telprompt://%@",self.factoryPhone.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma --mark UICollectionViewDataSourceDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.likeList.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LikeListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LikeListCell" forIndexPath:indexPath];
    CCMember * member = [self.likeList objectAtIndex:indexPath.item];
    [cell.avatar sd_setImageWithURL:[CCFile ccURLWithString:member.headImgUrl]];
    cell.nameLabel.text = member.username;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}




- (IBAction)collect:(id)sender
{
    
//    AVQuery * query = [AVQuery queryWithClassName:@"MallProduct"];
//    [query whereKey:@"factoryProduct" equalTo:self.product];
//    [query whereKey:@"shopId" equalTo:((AVObject *)[AVUser currentUser][@"shop"]).objectId];
//    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//        if (error) {
//            
//        } else {
//            
//        }
//    }];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CollectAlertView" owner:self options:nil];
    CollectAlertView *collectView = collectView = [nib objectAtIndex:0];
    collectView.delegate = self;
    collectView.titleLabel.text = self.parentItem.name;
    collectView.SNLabel.text = [@"货号: " stringByAppendingString:self.parentItem.SN];
    collectView.inPrice.text = [NSNumber numberWithFloat:self.parentItem.price].stringValue;
    [collectView showInView:self.view];
    
}

- (void)collectAlertViewCollectButtonClicked:(CollectAlertView *)view
{
    [SVProgressHUD showWithStatus:@"正在收藏" maskType:SVProgressHUDMaskTypeBlack];
    [CCItem collect:YES item:self.parentItem price:view.outPrice.text.floatValue withBlock:^(BOOL succeed, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"收藏失败"];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        }
    }];
}

- (void)collectAlertViewDidDismiss:(CollectAlertView *)view
{
}

- (IBAction)uncollect:(id)sender
{
    
}

- (IBAction)mallItemStatistics:(id)sender
{
    MallItemStatisticsViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MallItemStatisticsViewController"];
    vc.parentItem = self.parentItem;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)factoryItemStatistics:(id)sender
{
    FactoryItemStatisticsViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FactoryItemStatisticsViewController"];
    vc.parentItem = self.parentItem;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)want:(id)sender
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WantView" owner:self options:nil];
    WantView * wantView = [nib objectAtIndex:0];
    wantView.parentItem = self.parentItem;
    wantView.title.text = self.parentItem.name;
    wantView.price.text = [NSNumber numberWithFloat:self.parentItem.price].stringValue;
    wantView.idLabel.text = [@"货号:" stringByAppendingString:self.parentItem.SN];
    [wantView.thumbnail sd_setImageWithURL:[CCFile ccURLWithString:self.parentItem.cover]];
    wantView.delegate = self;
    [wantView showInView:self.view];
}

- (void)wantViewOKButtonClicked:(WantView *)view
{
    [SVProgressHUD showWithStatus:@"正在处理" maskType:SVProgressHUDMaskTypeBlack];
    [CCItem want:YES item:self.parentItem color:view.selectedColor size:view.selectedSize byMemberMobile:view.userIdLabel.text withBlock:^(BOOL succeed, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"网络错误、想要处理失败"];
        } else {
            if (succeed) [SVProgressHUD showSuccessWithStatus:@"处理成功"];
            else [SVProgressHUD showErrorWithStatus:@"想要处理失败"];
        }
    }];
}
- (void)wantViewDidDismiss:(WantView *)view
{
}

- (IBAction)unsell:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确认要下架吗？"
                                                     message:@"下架后将无法恢复"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确认", nil];
    alert.tag = 1001;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [SVProgressHUD showWithStatus:@"正在操作" maskType:SVProgressHUDMaskTypeBlack];
            [CCItem unsellItem:self.parentItem withBlock:^(BOOL succeed, NSError *error) {
                [SVProgressHUD dismiss];
                if (succeed) {
                    [SVProgressHUD showSuccessWithStatus:@"下架成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"操作失败"];
                }
            }];
        }
    }
}

@end
