//
//  SecretCode.h
//  HiddenApi
//
//  Created by Vincent on 14-12-10.
//  Copyright (c) 2014年 Vincent. All rights reserved.
//

/****************************************
 
 请导入libMobileGestalt.dylib库
 
 iOS 7以下无需越狱
 iOS 7及以上需要越狱，并在entitlements中添加com.apple.private.MobileGestalt.AllowedProtectedKeys  Array
 在com.apple.private.MobileGestalt.AllowedProtectedKeys中添加对应的值（如需要UDUD，则添加UniqueDeviceID）
 
 ****************************************/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SecretCode : NSObject

+ (NSString *)UDID;

+ (NSString *)IMEI;

+ (NSString *)ICCID;

+ (NSString *)serialNumber;

+ (NSString *)wifiAddress;

+ (NSString *)bluetoothAddress;

+ (NSString *)cpuArchitecture;//无需越狱

+ (NSString *)productType;//无需越狱

+ (BOOL)airplaneMode;//无需越狱
+(NSString*)SaveCHKeyNew:(NSString *)ckey setvalue:(NSString *)cvalue issave:(BOOL)csave; //   保存全局数据，只有刷机可清除

@end
