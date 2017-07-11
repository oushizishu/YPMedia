//
//  NSDictionary+BJCFDataValue.h
//  Pods
//
//  Created by Randy on 16/02/19.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BJCFDataValue)

- (int)BJCF_intForKey:(NSString *)key;
- (NSInteger)BJCF_integerForKey:(NSString *)key;
- (long)BJCF_longForKey:(NSString *)key;
- (long long)BJCF_longLongForKey:(NSString *)key;
- (float)BJCF_floatForKey:(NSString *)key;
- (double)BJCF_doubleForKey:(NSString *)key;
- (BOOL)BJCF_boolForKey:(NSString *)key;
- (NSString *)BJCF_stringForKey:(NSString *)key DEPRECATED_MSG_ATTRIBUTE("use `BJCF_stringForKey:defaultValue:`");
- (NSArray *)BJCF_arrayForKey:(NSString *)key;
- (NSDictionary *)BJCF_dictionaryForKey:(NSString *)key;
- (NSDate *)BJCF_dateForKey:(NSString *)key;
- (NSURL *)BJCF_urlForKey:(NSString *)key;

- (int)BJCF_intForKey:(NSString *)key defaultValue:(int)defaultValue;
- (NSInteger)BJCF_integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (long)BJCF_longForKey:(NSString *)key defaultValue:(long)defaultValue;
- (long long)BJCF_longLongForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (float)BJCF_floatForKey:(NSString *)key defaultValue:(float)defaultValue;
- (double)BJCF_doubleForKey:(NSString *)key defaultValue:(double)defaultValue;
- (BOOL)BJCF_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (NSString *)BJCF_stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSDate *)BJCF_dateForKey:(NSString *)key defaultValue:(NSDate *)defaultValue;
- (NSURL *)BJCF_urlForKey:(NSString *)key defaultValue:(NSURL *)defaultValue;
- (NSURL *)BJCF_urlForKeyFromUrlOrString:(NSString *)key defaultValue:(NSURL *)defaultValue;

@end
