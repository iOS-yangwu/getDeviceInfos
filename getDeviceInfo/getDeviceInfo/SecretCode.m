//
//  SecretCode.m
//  HiddenApi
//
//  Created by Vincent on 14-12-10.
//  Copyright (c) 2014年 Vincent. All rights reserved.
//

#import "SecretCode.h"
#import  "CHKeychain.h"
#include <dlfcn.h>
#include <CoreFoundation/CoreFoundation.h>
//char * CFNumberToString (CFNumberRef 	Num); // I loathe CoreFoundation
CFTypeRef (*MGCopyAnswer_func)(CFStringRef question);
NSString * const KEY_USERNAME_UUID = @"com.ihmedai.dzg.uuid";
NSString * const KEY_USERNAME_IHMEDIA = @"com.ihmedai.dzg";
NSString * const KEY_USERNAME = @"com.ihmedai.dzg.userid";
static const char kKeychainUDIDItemIdentifier[]  = "UUID";
static const char kKeyChainUDIDAccessGroup[] = "com.ihmedia.DZG";
@implementation SecretCode


+ (NSString *)UDID {
    
    
    if (kCFCoreFoundationVersionNumber < 800) {//iOS 7以下
        
        NSString *udid = [[UIDevice currentDevice] valueForKey:@"uniqueIdentifier"];
        
        return udid;
    }
    
    
    if (!MGCopyAnswer_func)
    {
        void *gestaltLib = dlopen ("/usr/lib/libMobileGestalt.dylib", RTLD_LAZY);
        
        if (!gestaltLib)  { /* error */ return NULL;}
        
        // Found library, now find symbol
        MGCopyAnswer_func = dlsym (gestaltLib, "MGCopyAnswer");
        
        if (!MGCopyAnswer_func)  { /* error */ return NULL;}
        dlclose(gestaltLib);
    }
    
    
    CFTypeRef answer = MGCopyAnswer_func(CFSTR("DieId"));
    
    return (__bridge NSString *)(answer);
}

+ (NSString *)IMEI {

    //CFStringRef result = MGCopyAnswer(CFSTR("InternationalMobileEquipmentIdentity"));
    
    return @"123";
}

+ (NSString *)ICCID {
    
    /*
    NSString *retVal = nil;
    CFArrayRef infoArray = MGCopyAnswer(CFSTR("CarrierBundleInfoArray"));
    if (infoArray) {
        CFDictionaryRef infoDic = CFArrayGetValueAtIndex(infoArray, 0);
        if (infoDic) {
            retVal = [NSString stringWithString:CFDictionaryGetValue(infoDic, CFSTR("IntegratedCircuitCardIdentity"))];
        }
        CFRelease(infoArray);
    }
     */
    return @"";
}

+ (NSString *)serialNumber {
    
    //CFStringRef result = MGCopyAnswer(CFSTR("SerialNumber"));
    
    return @"";
}

+ (NSString *)wifiAddress {
    
   // CFStringRef result = MGCopyAnswer(CFSTR("WifiAddress"));
    
    return @"";
}

+ (NSString *)bluetoothAddress {
    
   // CFStringRef result = MGCopyAnswer(CFSTR("BluetoothAddress"));
    
    return @"";
}

+ (NSString *)cpuArchitecture {
    
  //  CFStringRef result = MGCopyAnswer(CFSTR("CPUArchitecture"));
    
    return @"";
}

+ (NSString *)productType {
    
   // CFStringRef result = MGCopyAnswer(CFSTR("ProductType"));
    
    return @"";
}

+ (BOOL)airplaneMode {
    
    /*
    BOOL retVal = NO;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("AirplaneMode"));
    if (tmp) {
        if (tmp == kCFBooleanTrue) {
            retVal = YES;
        }
        CFRelease(tmp);
    }
     */
    return @"";
}
+(NSString*)SaveCHKeyNew:(NSString *)ckey setvalue:(NSString *)cvalue issave:(BOOL)csave
{
    
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_IHMEDIA];
    NSString *udid = [usernamepasswordKVPairs objectForKey:ckey];
    NSLog(@"UDID--Old-%@:",udid);
    if (!udid&&csave) {
        
        // udid = [OpenUDID value];
        udid =cvalue;
        
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [usernamepasswordKVPairs setObject:udid forKey:ckey];
        
        [CHKeychain save:KEY_USERNAME_IHMEDIA data:usernamepasswordKVPairs];
        NSLog(@"UDID--NEW ");
        if([ckey containsString:@"isactive"])
        {
            udid=@"";
        }
    }
    
    return udid;
}
@end
