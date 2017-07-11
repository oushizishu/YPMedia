//
//  NSDictionary+BJCF.m
//  Pods
//
//  Created by Randy on 16/3/30.
//
//

#import "NSDictionary+BJCF.h"

@implementation NSDictionary (BJCF)

- (NSDictionary *)BJCF_addEntriesFromDictionary:(nullable NSDictionary *)entries
{
    if (entries.count>0) {
        NSMutableDictionary *mutDic = [self mutableCopy];
        [mutDic addEntriesFromDictionary:entries];
        return [mutDic copy];
    }
    return self;
}

@end
