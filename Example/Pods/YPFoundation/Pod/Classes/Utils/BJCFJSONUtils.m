//
//  BJCFJsonUtils.m
//  Pods
//
//  Created by Randy on 16/2/19.
//
//

#import "BJCFJSONUtils.h"

@implementation BJCFJSONUtils

+ (NSData *)BJCF_jsonToData:(id)json
{
    if (!json) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] == 0 || error != nil) {
        return nil;
    }
    
    return jsonData;
}

+ (NSString *)BJCF_jsonToString:(id)json
{
    NSData *data = [BJCFJSONUtils BJCF_jsonToData:json];
    if (!data) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (id)BJCF_dataToJson:(NSData *)data;
{
    if (!data) {
        return nil;
    }
    
    __autoreleasing NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!result || error != nil) {
        return nil;
    }
    
    return result;
}

+ (id)BJCF_stringToJson:(NSString *)string;
{
    if (!string) {
        return nil;
    }
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return nil;
    }
    
    __autoreleasing NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) {
        return nil;
    }
    
    return result;
}

@end
