//
//  NSString+BJCFVersion.h
//  Pods
//
//  Created by Randy on 16/2/19.
//
//

#import <Foundation/Foundation.h>

@interface NSString (BJCFVersion)

-(BOOL)BJCF_isOlderThanVersion:(NSString *)version;
-(BOOL)BJCF_isNewerThanVersion:(NSString *)version;
-(BOOL)BJCF_isEqualToVersion:(NSString *)version;
-(BOOL)BJCF_isEqualOrOlderThanVersion:(NSString *)version;
-(BOOL)BJCF_isEqualOrNewerThanVersion:(NSString *)version;

@end
