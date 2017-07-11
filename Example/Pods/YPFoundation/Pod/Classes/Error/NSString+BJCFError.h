//
//  NSString+BJCFError.h
//  Pods
//
//  Created by Randy on 15/12/31.
//
//

#import <Foundation/Foundation.h>
#import "BJCFError.h"
@interface NSString (BJCFError)

/**
 *  通过字符串返回 BJPErrorInteger 值
 *
 *  @return
 */
- (BJCFErrorInteger)bjcf_errorIntegerValue;

@end
