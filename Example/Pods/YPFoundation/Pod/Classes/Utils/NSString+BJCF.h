//
//  NSString+Utils.h
//  Pods
//
//  Created by Randy on 15/11/27.
//
//

#import <Foundation/Foundation.h>

@interface NSString (BJCF)

/**
 *  检查字符串是否符合正则表达式
 *
 *  @param aStr 正则表达式
 *
 *  @return 符合：YES，不符合：NO
 */
- (BOOL)bjcf_evaluateWithRegex:(NSString *)aStr;

/**
 *  检查包含是否是重复的数字
 *
 *  @param count 重复几次 大于1
 *
 *  @return 重复：YES count小于2：NO
 */
- (BOOL)bjcf_isRepeatNum:(NSInteger)count;

/**
 *  是合法的身份证号 15或18位，最后一位可以是字母，其他都必须是数字
 *
 *  @return 合法：YES
 */
- (BOOL)bjcf_isLegalOwnerId;


/**
 *  检测是否是纯数字字符串
 *
 *  @return 是：YES
 */
- (BOOL)bjcf_isOnlyNumber;

/**
 *  去掉非数字的字符
 *
 *  @return
 */
- (NSString *)bjcf_removeNonNumberStr;

@end
