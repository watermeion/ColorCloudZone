//
//  GBBaseStoryboardViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 11/22/15.
//  Copyright © 2015 SHS. All rights reserved.
//

#import "GBBaseStoryboardViewController.h"

@interface GBBaseStoryboardViewController ()

@end

@implementation GBBaseStoryboardViewController

static NSString* _classForStoryboard;


+ (NSString *) classForStoryboard{
    
    return  [_classForStoryboard copy];
}


+ (void)setClassForStoryboard:(NSString *)classString{
    
    if ([NSClassFromString(classString) isSubclassOfClass:[self class]]) {
        _classForStoryboard = classString;
    }
    else{
        _classForStoryboard = nil;
    }
}



+ (instancetype)alloc{
    
    if (_classForStoryboard.length == 0) {
        return [super alloc];
    }
    if (NSClassFromString(_classForStoryboard) != [self class]) {
        
        id ret = [NSClassFromString(_classForStoryboard) alloc];
        [self setClassForStoryboard:nil];
        return ret;
    }
    return [super alloc];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
