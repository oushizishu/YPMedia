//
//  UIDevice(Identifier).m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "UIDevice+BJCFIdentifier.h"
#import "BJCFKeychain.h"
#import "NSString+BJCFMD5.h"
#import <Security/Security.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
@interface UIDevice(BJCFPrivate)

- (NSString *) bjcf_macaddress;

@end

@implementation UIDevice (BJCFIdentifier)

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) bjcf_macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

- (NSString *) bjcf_uniqueDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] bjcf_macaddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *uniqueIdentifier = [stringToHash bjcf_stringFromMD5];
    
    return uniqueIdentifier;
}

- (NSString *) bjcf_uniqueGlobalDeviceIdentifier{
    return [UIDevice bjcf_getUUIDFromKeyChain];
    //return [SvUDIDTools UDID];
}

+ (NSString *)bjcf_bundleSeedID {
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)(kSecClassGenericPassword), kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge id)(kSecAttrAccessGroup)];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}

+ (NSString *)bjcf_getUmengUDID
{
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = NSSelectorFromString(@"openUDIDString");
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        deviceID = [cls performSelector:deviceIDSelector];
#pragma clang diagnostic pop
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+ (NSString *)bjcf_getUUIDFromKeyChain
{
    NSString *keyChainIdentifier = @"BJUUID";
    NSString *keyChainService = @"com.bjhl.genshuixue";
    
    //[SSKeychain deletePasswordForService:bundleIdentifier account:keyChainIdentifier];
    NSString *keyChainGroup = [NSString stringWithFormat:@"%@.family", [UIDevice bjcf_bundleSeedID] ];
    NSString *retrieveuuid = [BJCFKeychain passwordForService:keyChainService account:keyChainIdentifier accessGroup:keyChainGroup];
    
    if (retrieveuuid==nil||[retrieveuuid isEqualToString:@""])
    {
        NSString *did = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [BJCFKeychain setPassword:did
                     forService:keyChainService account:keyChainIdentifier accessGroup:keyChainGroup];
        return did;
    }
    else
    {
        return retrieveuuid;
    }
}

+ (NSString *)bjcf_platformString
{
    size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
    return platform;
}

+ (NSString* )bjcf_platformName
{
    size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *deviceString = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);

    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5(AT&T)";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5(GSM/CDMA)";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    //iPod Touch
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    //Simulator
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";

    return @"unknow";
}

+ (BOOL)bjcf_isLowDevice
{
    size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *deviceString = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return YES;
    if ([deviceString isEqualToString:@"iPhone1,2"])    return YES;
    if ([deviceString isEqualToString:@"iPhone2,1"])    return YES;
    if ([deviceString isEqualToString:@"iPhone3,1"])    return YES;
    if ([deviceString isEqualToString:@"iPhone3,2"])    return YES;
    //if ([deviceString isEqualToString:@"iPhone4,1"])    return NO;
    //if ([deviceString isEqualToString:@"iPhone5,1"])    return NO;
    //if ([deviceString isEqualToString:@"iPhone5,2"])    return NO;
    //iPod Touch
    if ([deviceString isEqualToString:@"iPod1,1"])      return YES;
    if ([deviceString isEqualToString:@"iPod2,1"])      return YES;
    if ([deviceString isEqualToString:@"iPod3,1"])      return YES;
    if ([deviceString isEqualToString:@"iPod4,1"])      return YES;
    //if ([deviceString isEqualToString:@"iPod5,1"])      return NO;
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return YES;
    if ([deviceString isEqualToString:@"iPad2,1"])      return YES;
    if ([deviceString isEqualToString:@"iPad2,2"])      return YES;
    if ([deviceString isEqualToString:@"iPad2,3"])      return YES;
    //if ([deviceString isEqualToString:@"iPad2,5"])      return NO;
    //if ([deviceString isEqualToString:@"iPad2,6"])      return NO;
    //if ([deviceString isEqualToString:@"iPad2,7"])      return NO;
    if ([deviceString isEqualToString:@"iPad3,1"])      return YES;
    if ([deviceString isEqualToString:@"iPad3,2"])      return YES;
    if ([deviceString isEqualToString:@"iPad3,3"])      return YES;
    //if ([deviceString isEqualToString:@"iPad3,4"])      return NO;
    //if ([deviceString isEqualToString:@"iPad3,5"])      return NO;
    //if ([deviceString isEqualToString:@"iPad3,6"])      return NO;
    //Simulator
    //if ([deviceString isEqualToString:@"i386"])         return NO;
    //if ([deviceString isEqualToString:@"x86_64"])       return NO;
    
    return NO;
}

+ (BOOL)bjcf_iphone5Screen
{
    //UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize si = [UIScreen mainScreen].bounds.size;
        if (si.width == 320 && si.height == 568)
        {
            return YES;
        }
    }
    return NO;
}

+(BOOL) bjcf_isIos7
{
  CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
  return version >= 7.0f;
}


//+ (BOOL)hasMicrophone
//{
//    size_t size;
//	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//	char *machine = malloc(size);
//	sysctlbyname("hw.machine", machine, &size, NULL, 0);
//	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
//	free(machine);
//	
//    if ([platform isEqualToString:@"iPhone1,1"]) return YES;
//	if ([platform isEqualToString:@"iPhone1,2"]) return YES;
//	if ([platform isEqualToString:@"iPhone2,1"]) return YES;
//	if ([platform isEqualToString:@"iPhone3,1"]) return YES;
//	return NO;
//}
@end
