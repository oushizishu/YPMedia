//
//  NSDictionary+BJCFDataValue.m
//  Pods
//
//  Created by Randy on 16/02/19.
//

#import "NSDictionary+BJCFDataValue.h"
#import "NSDate+BJCF.h"

@implementation NSDictionary (BJCFDataValue)

- (int)BJCF_intForKey:(NSString *)key
{
    return [self BJCF_intForKey:key defaultValue:0];
}

- (NSInteger)BJCF_integerForKey:(NSString *)key
{
    return [self BJCF_integerForKey:key defaultValue:0];
}

- (long)BJCF_longForKey:(NSString *)key
{
    return [self BJCF_longForKey:key defaultValue:0];
}

- (long long)BJCF_longLongForKey:(NSString *)key
{
    return [self BJCF_longLongForKey:key defaultValue:0];
}

- (float)BJCF_floatForKey:(NSString *)key
{
    return [self BJCF_floatForKey:key defaultValue:0.0f];
}

- (double)BJCF_doubleForKey:(NSString *)key
{
    return [self BJCF_doubleForKey:key defaultValue:0.0];
}

- (BOOL)BJCF_boolForKey:(NSString *)key
{
    return [self BJCF_boolForKey:key defaultValue:NO];
}

- (NSString *)BJCF_stringForKey:(NSString *)key
{
    return [self BJCF_stringForKey:key defaultValue:@""];
}

- (NSArray *)BJCF_arrayForKey:(NSString *)key;
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)BJCF_dictionaryForKey:(NSString *)key;
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSDate *)BJCF_dateForKey:(NSString *)key;
{
    return [self BJCF_dateForKey:key defaultValue:nil];
}

- (NSURL *)BJCF_urlForKey:(NSString *)key;
{
    return [self BJCF_urlForKey:key defaultValue:nil];
}

- (NSURL *)BJCF_urlForKeyFromUrlOrString:(NSString *)key;
{
    return [self BJCF_urlForKeyFromUrlOrString:key defaultValue:nil];
}

#pragma mark -defaultValue

- (int)BJCF_intForKey:(NSString *)key defaultValue:(int)defaultValue
{
    id value = [self objectForKey:key];
    return [value respondsToSelector:@selector(intValue)] ? [value intValue] : defaultValue;
}

- (NSInteger)BJCF_integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue
{
    id value = [self objectForKey:key];
    return [value respondsToSelector:@selector(integerValue)] ? [value integerValue] : defaultValue;
}

- (long)BJCF_longForKey:(NSString *)key defaultValue:(long)defaultValue
{
    id value = [self objectForKey:key];
    return [value respondsToSelector:@selector(longValue)] ? [value longValue] : defaultValue;
}

- (long long)BJCF_longLongForKey:(NSString *)key defaultValue:(long long)defaultValue
{
    id value = [self objectForKey:key];
    return [value respondsToSelector:@selector(longLongValue)] ? [value longLongValue] : defaultValue;
}

- (float)BJCF_floatForKey:(NSString *)key defaultValue:(float)defaultValue
{
    id value = [self objectForKey:key];
    return [value respondsToSelector:@selector(floatValue)] ? [value floatValue] : defaultValue;
}

- (double)BJCF_doubleForKey:(NSString *)key defaultValue:(double)defaultValue
{
    id value = [self objectForKey:key];
    return [value respondsToSelector:@selector(doubleValue)] ? [value doubleValue] : defaultValue;
}

- (BOOL)BJCF_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
    id value = [self objectForKey:key];
    return [value respondsToSelector:@selector(boolValue)] ? [value boolValue] : defaultValue;
}

- (NSString *)BJCF_stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    }
    if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    }
    return defaultValue;
}

- (NSDate *)BJCF_dateForKey:(NSString *)key defaultValue:(NSDate *)defaultValue;
{
    id value = [self objectForKey:key];
    return [value isKindOfClass:[NSDate class]] ? value : defaultValue;
}

- (NSURL *)BJCF_urlForKey:(NSString *)key defaultValue:(NSURL *)defaultValue;
{
    id value = [self objectForKey:key];
    return [value isKindOfClass:[NSURL class]] ? value : defaultValue;
}


- (NSURL *)BJCF_urlForKeyFromUrlOrString:(NSString *)key defaultValue:(NSURL *)defaultValue;
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSURL class]]) {
        return value;
    }
    else if ([value isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL URLWithString:value];
        if (url) {
            return url;
        }
    }
    return defaultValue;
}

@end
