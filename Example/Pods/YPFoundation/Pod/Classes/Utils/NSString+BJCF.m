//
//  NSString+Utils.m
//  Pods
//
//  Created by Randy on 15/11/27.
//
//

#import "NSString+BJCF.h"

@implementation NSString (BJCF)

/**
 *  检查字符串是否符合正则表达式
 *
 *  @param aStr 正则表达式
 *
 *  @return 符合：YES，不符合：NO
 */
- (BOOL)bjcf_evaluateWithRegex:(NSString *)aStr
{
    NSString *regex = aStr;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}


/**
 *  是合法的身份证号 15或18位，最后一位可以是字母，其他都必须是数字
 *
 *  @return 合法：YES
 */
- (BOOL)bjcf_isLegalOwnerId;
{
    return [self bjcf_evaluateWithRegex:@"^[0-9]{14,17}[A-Za-z0-9]$"];
}

/**
 *  检查包含是否是重复的数字
 *
 *  @param count 重复几次 大于1
 *
 *  @return 重复：YES count小于2：NO
 */
- (BOOL)bjcf_isRepeatNum:(NSInteger)count;
{
    if (count<2) {
        return NO;
    }
    return [self bjcf_evaluateWithRegex:[NSString stringWithFormat:@"[0-9]*?(\\d)\\1{%ld}[0-9]*?",(long)(count-1)]];
}

/**
 *  检测是否是纯数字字符串
 *
 *  @return 是：YES
 */
- (BOOL)bjcf_isOnlyNumber
{
    return [self bjcf_evaluateWithRegex:@"^[0-9]*"];
}

/**
 *  去掉非数字的字符
 *
 *  @return
 */
- (NSString *)bjcf_removeNonNumberStr;
{
    NSMutableString *mutStr = [NSMutableString new];
    for (int i=0; i<self.length; i++) {
        NSString *oneStr = [self substringWithRange:NSMakeRange(i, 1)];
        if ([oneStr bjcf_isOnlyNumber]) {
            [mutStr appendString:oneStr];
        }
    }
    return [mutStr copy];
}

@end
