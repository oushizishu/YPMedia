//
//  BJCFJsonUtils.h
//  Pods
//
//  Created by Randy on 16/2/19.
//
//

#import <Foundation/Foundation.h>

@interface BJCFJSONUtils : NSObject

/**
 将 dictionary 或者 array 转位 Data or string
 */
+ (NSData *)BJCF_jsonToData:(id)json;
+ (NSString *)BJCF_jsonToString:(id)json;

//将Json string or data转化为NSArray or NSDictionary
+ (id)BJCF_dataToJson:(NSData *)data;
+ (id)BJCF_stringToJson:(NSString *)string;

@end
