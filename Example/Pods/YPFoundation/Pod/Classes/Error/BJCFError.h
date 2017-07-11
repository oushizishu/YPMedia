//
//  BJCFError.h
//  Pods
//
//  Created by Randy on 15/11/27.
//
//

#import <Foundation/Foundation.h>

typedef
#if _OS_IS_64
long
#else
long long
#endif
BJCFErrorInteger;

@interface BJCFError : NSObject
@property (assign, readonly, nonatomic) BJCFErrorInteger code;
@property (copy, readonly, nonatomic) NSString *reason;
@property (copy, readonly, nonatomic) NSString *domain;

@property (assign, readonly, nonatomic) NSInteger originalCode;
@property (copy, readonly, nonatomic) NSString *originalReason;

/**
 *  配置error 的默认选项
 *
 *  @param domain    error
 *  @param query     问题侧
 *  @param subsystem 子系统
 *  @param platform  平台
 */
+ (void)configDefaultWithDomain:(NSString *)domain
                          query:(NSString *)query
                      subsystem:(NSString *)subsystem
                       platform:(NSString *)platform;

+ (BJCFError *)errorWithDomain:(NSString *)domain
                         code:(BJCFErrorInteger)code
                       reason:(NSString *)reason;
+ (BJCFError *)errorWithCode:(BJCFErrorInteger)code
                     reason:(NSString *)reason;
+ (BJCFError *)errorWithError:(NSError *)error;

/**
 *  把本地的code转换为标准的10位code码。 code会先去掉非数字字符，并转换为4位字符
 *
 *  @param code 本地code，例如：NSError
 *
 *  @return
 */
+ (BJCFErrorInteger)errorCodeWithCode:(NSInteger)code;
@end
