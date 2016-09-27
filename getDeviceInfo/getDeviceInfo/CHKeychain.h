//
//  AppDelegate.m
//  getDeviceInfo
//
//  Created by 吴洋 on 2016/9/27.
//  Copyright © 2016年 com.zhicheng.www. All rights reserved.

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface CHKeychain : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
