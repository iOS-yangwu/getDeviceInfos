//
//  NSString+extension.m
//  openGenList
//
//  Created by 吴洋 on 2016/9/13.
//  Copyright © 2016年 com.zhicheng.www. All rights reserved.
//

#import "NSObject+extension.h"
#import "sys/utsname.h"
#import <AdSupport/ASIdentifierManager.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <UIKit/UIKit.h>
#import <mach/host_info.h>
#import <mach/task_info.h>
#import <mach/task.h>
#include <sys/types.h>
#import <Security/Security.h>
#import <mach/mach_host.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <net/ethernet.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CoreTelephonyDefines.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "CommonCrypto/CommonDigest.h"
#import  "SecretCode.h"
#import <objc/runtime.h>
#include <string.h>
#import <mach-o/loader.h>
#import <mach-o/dyld.h>
#import <mach-o/arch.h>

@implementation NSObject (extension)

- (NSString *) getAllDeviceInfo{
    
    NSUserDefaults *dafaults = [NSUserDefaults standardUserDefaults];
    //identifierNumber
    UIDevice *device  = [UIDevice currentDevice];
    NSUUID *identifierNumber = [device identifierForVendor];
    
    //UUID
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuident =(NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));
    
    
    //userPhoneName
    NSString* userPhoneName = [device name];
    
    //deviceName
    NSString* deviceName = [device systemName];
    
    //phoneVersion
    NSString* phoneVersion = [device systemVersion];
    
    
    //mCarrier
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    
    //mConnectType
    NSString *mConnectType = [[NSString alloc] initWithFormat:@"%@",info.currentRadioAccessTechnology];
    
    //IDFA
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    //mac
    NSString *macAddress = [self getMacAddress];
    
    //广告追踪标识符
    NSString *adTrackingEnable = [self getaAdTrackingEnabled];
    
    //IDFV
    NSString *IDFV = [SecretCode UDID];
    
    NSString *device_model = [self getCurrentDeviceModel];
    
    
    
    //网络类型
    NSString *netType = [self GetnetType];
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString *netWorkInfoRadio = networkInfo.currentRadioAccessTechnology;
    
    NSString *deviceToken = [dafaults objectForKey:@"deviceToken"];
    
    
    //wifi
    NSString *wifi = [self localWiFiIPAddress];
    
    //电池信息
    NSString *batteryMoniter = [self batteryMoniters];
    
    //内存信息
    NSString *memoryInfo = [self logMemoryInfo];
    
    //ssid bssid ssiddata
    NSString *ssid           = nil;
    NSString *bssid          = nil;
    NSString *ssiddata       = nil;
    
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    for (NSString *ifnam in ifs) {
        NSDictionary *info = CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)ifnam));
        
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
            
        }
        if (info[@"BSSID"]) {
            bssid = info[@"BSSID"];
            
        }
        if (info[@"SSIDDATA"]) {
            ssiddata = info[@"SSIDDATA"];
            
        }
    }
    
    //内存大小
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager* fileManager      = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace             = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace            = [fileSysAttributes objectForKey:NSFileSystemSize];
    
    CGFloat totalSpac = [totalSpace longLongValue]/1024.0/1024.0/1024.0;
    CGFloat freeSpac  = [freeSpace longLongValue]/1024.0/1024.0/1024.0;
    NSDate *date = [NSDate date];
    //时间
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"HH-mm-ss yyyy-MM-dd"];
    NSString *timeStr = [forMatter stringFromDate:date];

    //屏幕大小
    UIScreen *currentScreen         = [UIScreen mainScreen];
    NSString *userScreen               = [NSString stringWithFormat:@"%d*%d",(int)currentScreen.applicationFrame.size.height,(int)currentScreen.applicationFrame.size.width];
    
    //时区
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    
    //蓝牙
    NSString *bluetooth = [[NSUserDefaults standardUserDefaults] objectForKey:@"locket"];
    
    NSString * allDeviceInfo = [NSString stringWithFormat:@"{\"IDFA\":\"%@\",\"IDFV\":\"%@\",\"IMEI\":\"%@\",\"carrieroperator\":\"%@\",\"photoType\":\"%@-%@\",\"nettype\":\"%@\",\"deviceToken\":\"%@\",\"macAddress\":\"%@\",\"bssid\":\"%@\",\"ssiddata\":\"%@\",\"ssid\":\"%@\",\"localIP\":\"%@\",\"time\":\"%@\",\"memoryinfo\":\"%@\",\"batteryMoniter\":\"%@\",\"totalSpace\":\"%.1f\",\"freeSpace\":\"%.1f\",\"screen\":\"%@\",\"identifierNumber\":\"%@\",\"UUID\":\"%@\",\"userPhoneName\":\"%@\",\"mCarrier\":\"%@\",\"mConnectType\":\"%@\",\"adTrackingEnable\":\"%@\",\"localTimeZone\":\"%@\"}",idfa,IDFV,netWorkInfoRadio,device_model,deviceName,phoneVersion,netType,deviceToken,macAddress,bssid,ssiddata,ssid,wifi,timeStr,memoryInfo,batteryMoniter,totalSpac,freeSpac,userScreen,identifierNumber,uuident,userPhoneName,mCarrier,mConnectType,adTrackingEnable,localTimeZone];
    
    return allDeviceInfo;
    
}
//内存信息
-(NSString *)logMemoryInfo{
    
    int mib[6];
    mib[0] = CTL_HW;
    mib[1] = HW_PAGESIZE;
    
    int pagesize;
    size_t length;
    length = sizeof (pagesize);
    if (sysctl (mib, 2, &pagesize, &length, NULL, 0) < 0)
    {
        fprintf (stderr, "getting page size");
    }
    
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    
    vm_statistics_data_t vmstat;
    if (host_statistics (mach_host_self (), HOST_VM_INFO, (host_info_t) &vmstat, &count) != KERN_SUCCESS)
    {
        fprintf (stderr, "Failed to get VM statistics.");
    }
    task_basic_info_64_data_t info;
    unsigned size = sizeof (info);
    task_info (mach_task_self (), TASK_BASIC_INFO_64, (task_info_t) &info, &size);
    
    double unit     = 1024 * 1024;
    double total    = (vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count) * pagesize / unit;
    double wired    = vmstat.wire_count * pagesize / unit;
    double active   = vmstat.active_count * pagesize / unit;
    double inactive = vmstat.inactive_count * pagesize / unit;
    double free     = vmstat.free_count * pagesize / unit;
    double resident = info.resident_size / unit;
    
    NSString * MemoryInfo=[NSString stringWithFormat:@"total:%2lfMb-Wired:%.2lfMb-Active:%.2lfMb-Inactive:%.2lfMb-Free:%.2lfMb-Resident:%.2lfMb",total,wired,active,inactive,free,resident];
    return MemoryInfo;
    
}

//电池信息
- (NSString *)batteryMoniters {
    UIDevice *device                = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    NSString * battery              = nil;
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        
        NSLog(@"UnKnow");
        battery=@"UnKnow";
        
    }else if (device.batteryState == UIDeviceBatteryStateUnplugged){
        
        NSLog(@"Unplugged");
        battery=@"Unplugged";
        
    }else if (device.batteryState == UIDeviceBatteryStateCharging){
        
        NSLog(@"Charging");
        battery=@"Charging";
    }else if (device.batteryState == UIDeviceBatteryStateFull){
        
        NSLog(@"Full");
        battery=@"Full";
    }
    
    NSString *level=[NSString stringWithFormat:@"%f-%@",device.batteryLevel,battery];
    return  level;
}
//mac地址
- (NSString *)getMacAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}

// 获取广告限制开关
- (NSString *)getaAdTrackingEnabled{
    
    if ([ASIdentifierManager sharedManager].advertisingTrackingEnabled) {
        
        return @"1";
        
    }else{
        
        return @"0";
        
    }
    
}

//获得设备型号
- (NSString *) getCurrentDeviceModel{
    
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

//网络类型
- (NSString *)GetnetType {
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NSString * netType = @"none";
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num == nil) {
        
        netType = @"none";
        
    }else{
        
        int n = [num intValue];
        if (n == 0) {
            netType = @"none";
        }else if (n == 1){
            netType = @"2G";
        }else if (n == 2){
            netType = @"3G";
        }else if (n == 3){
            netType = @"4G";
        }else{
            netType = @"WIFI";
        }
        
    }
    
    return netType;
}

//wifi
- (NSString *) localWiFiIPAddress{
    
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0){
                
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            
            cursor = cursor->ifa_next;
            
        }
        
        freeifaddrs(addrs);
    }
    return nil;
}




@end
