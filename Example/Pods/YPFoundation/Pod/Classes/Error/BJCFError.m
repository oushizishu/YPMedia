//
//  BJCFError.m
//  Pods
//
//  Created by Randy on 15/11/27.
//
//

#import "BJCFError.h"
#import "NSString+BJCFError.h"
#import "NSString+BJCF.h"
#define BJCFErrorConfigInstance [BJCFErrorConfig sharedInstance]

@interface BJCFErrorConfig : NSObject
@property (copy, nonatomic) NSString *domain;
@property (copy, nonatomic) NSString *query;
@property (copy, nonatomic) NSString *subsystem;
@property (copy, nonatomic) NSString *platform;

@end

@implementation BJCFErrorConfig

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _domain = @"BJHL-Foundation";
        _query = @"1";
        _subsystem = @"001";
        _platform = @"01";
    }
    return self;
}

@end

@interface BJCFError ()

@property (copy, nonatomic) NSString *reason;
@property (assign, nonatomic) BJCFErrorInteger code;
@property (copy, nonatomic) NSString *domain;
@property (assign, nonatomic) NSInteger originalCode;
@property (copy, nonatomic) NSString *originalReason;

@end

@implementation BJCFError

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
{
    BJCFErrorConfig *config = [BJCFErrorConfig sharedInstance];
    config.domain = domain;
    config.query = query;
    config.subsystem = subsystem;
    config.platform = platform;
}

+ (BJCFError *)errorWithDomain:(NSString *)domain code:(BJCFErrorInteger)code reason:(NSString *)reason;
{
    BJCFError *error = [[BJCFError alloc] init];
    error.domain = domain;
    error.code = code;
    error.reason = reason;
    return error;
}

+ (BJCFError *)errorWithCode:(BJCFErrorInteger)code reason:(NSString *)reason;
{
    return [BJCFError errorWithDomain:BJCFErrorConfigInstance.domain code:code reason:reason];
}

/**
 *  把本地的code转换为标准的10位code码。 如果本地code会先去掉非数字字符，并转换为4位字符
 *
 *  @param code 本地code，例如：NSError
 *
 *  @return
 */
+ (BJCFErrorInteger)errorCodeWithCode:(NSInteger)code
{
    NSString *originalStr = [[NSString stringWithFormat:@"%ld",code] bjcf_removeNonNumberStr];
    NSString *codeStr = originalStr.length>4?[originalStr substringFromIndex:originalStr.length - 4]:originalStr;
    while (codeStr.length<4) {
        codeStr = [NSString stringWithFormat:@"0%@",codeStr];
    }
    NSString *bjpStr = [NSString stringWithFormat:@"%@%@%@%@",BJCFErrorConfigInstance.query,BJCFErrorConfigInstance.subsystem,BJCFErrorConfigInstance.platform,codeStr];
    return [bjpStr bjcf_errorIntegerValue];
}

+ (BJCFError *)errorWithError:(NSError *)error;
{
    NSString *errorReason = error.localizedFailureReason;
    if (errorReason.length<=0) {
        if ([[error domain] isEqualToString:NSURLErrorDomain]) {
            errorReason = @"网络错误，请检查网络";
        }
        else
            errorReason = @"未知错误";
    }
    BJCFError *bjpError = [BJCFError errorWithDomain:error.domain code:[BJCFError errorCodeWithCode:error.code] reason:errorReason];
    bjpError.originalCode = error.code;
    bjpError.originalReason = error.localizedFailureReason?:error.localizedDescription;
    return bjpError;
}


@end
