//
//  ViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/13.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.image = [UIImage imageNamed:@"moreBarIcon_black@3x"];
    self.navigationItem.backBarButtonItem = backItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
