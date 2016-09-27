//
//  ViewController.m
//  getDeviceInfo
//
//  Created by 吴洋 on 2016/9/27.
//  Copyright © 2016年 com.zhicheng.www. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+extension.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"%@",[[NSObject new] getAllDeviceInfo]);
}




@end
