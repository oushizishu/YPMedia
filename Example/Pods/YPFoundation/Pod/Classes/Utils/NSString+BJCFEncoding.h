//
//  NSString+BJCFEncoding.h
//  Pods
//
//  Created by Randy on 16/2/19.
//
//

#import <Foundation/Foundation.h>

@interface NSString (BJCFEncoding)

- (NSString *)BJCF_urlEncodedString;
- (NSString *)BJCF_urlDecodedString;

@end
