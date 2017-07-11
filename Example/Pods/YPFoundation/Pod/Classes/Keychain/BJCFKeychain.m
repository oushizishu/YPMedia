//
//  SSKeychain.m
//  SSKeychain
//
//  Created by Sam Soffes on 5/19/10.
//  Copyright (c) 2010-2014 Sam Soffes. All rights reserved.
//

#import "BJCFKeychain.h"

NSString *const kBJCFKeychainErrorDomain = @"com.samsoffes.sskeychain";
NSString *const kBJCFKeychainAccountKey = @"acct";
NSString *const kBJCFKeychainCreatedAtKey = @"cdat";
NSString *const kBJCFKeychainClassKey = @"labl";
NSString *const kBJCFKeychainDescriptionKey = @"desc";
NSString *const kBJCFKeychainLabelKey = @"labl";
NSString *const kBJCFKeychainLastModifiedKey = @"mdat";
NSString *const kBJCFKeychainWhereKey = @"svce";

#if __IPHONE_4_0 && TARGET_OS_IPHONE
	static CFTypeRef BJCFKeychainAccessibilityType = NULL;
#endif

@implementation BJCFKeychain

+ (NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *) accessGroup{
	return [self passwordForService:serviceName account:account accessGroup:accessGroup error:nil];
}


+ (NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *) accessGroup error:(NSError *__autoreleasing *)error {
	BJCFKeychainQuery *query = [[BJCFKeychainQuery alloc] init];
	query.service = serviceName;
	query.account = account;
    query.accessGroup  = accessGroup;
	[query fetch:error];
	return query.password;
}


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *) accessGroup {
	return [self deletePasswordForService:serviceName account:account accessGroup:accessGroup error:nil];
}


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *) accessGroup error:(NSError *__autoreleasing *)error {
	BJCFKeychainQuery *query = [[BJCFKeychainQuery alloc] init];
	query.service = serviceName;
	query.account = account;
    query.accessGroup = accessGroup;
	return [query deleteItem:error];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account accessGroup:(NSString *) accessGroup{
	return [self setPassword:password forService:serviceName account:account accessGroup:accessGroup error:nil];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account  accessGroup:(NSString *) accessGroup error:(NSError *__autoreleasing *)error {
	BJCFKeychainQuery *query = [[BJCFKeychainQuery alloc] init];
	query.service = serviceName;
	query.account = account;
	query.password = password;
    query.accessGroup = accessGroup;
	return [query save:error];
}


+ (NSArray *)allAccounts {
	return [self accountsForService:nil];
}


+ (NSArray *)accountsForService:(NSString *)serviceName {
	BJCFKeychainQuery *query = [[BJCFKeychainQuery alloc] init];
	query.service = serviceName;
	return [query fetchAll:nil];
}


#if __IPHONE_4_0 && TARGET_OS_IPHONE
+ (CFTypeRef)accessibilityType {
	return BJCFKeychainAccessibilityType;
}


+ (void)setAccessibilityType:(CFTypeRef)accessibilityType {
	CFRetain(accessibilityType);
	if (BJCFKeychainAccessibilityType) {
		CFRelease(BJCFKeychainAccessibilityType);
	}
	BJCFKeychainAccessibilityType = accessibilityType;
}
#endif

@end
