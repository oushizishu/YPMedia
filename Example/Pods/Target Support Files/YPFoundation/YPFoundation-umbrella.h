#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BJCFAction.h"
#import "BJCommonDefines.h"
#import "BJCFError.h"
#import "NSString+BJCFError.h"
#import "BJCFCacheManagerTool.h"
#import "BJCFFileManagerTool.h"
#import "BJCFJockey.h"
#import "BJCFKeychain.h"
#import "BJCFKeychainQuery.h"
#import "BJCFJSONUtils.h"
#import "BJCFTimer.h"
#import "NSArray+BJCF.h"
#import "NSDate+BJCF.h"
#import "NSDateFormatter+BJCF.h"
#import "NSDictionary+BJCF.h"
#import "NSDictionary+BJCFDataValue.h"
#import "NSObject+BJCFBlockKVO.h"
#import "NSString+BJCF.h"
#import "NSString+BJCFEncoding.h"
#import "NSString+BJCFMD5.h"
#import "NSString+BJCFSize.h"
#import "NSString+BJCFVersion.h"
#import "NSURL+BJCFURLQuery.h"
#import "UIDevice+BJCFIdentifier.h"
#import "YPFoundation.h"

FOUNDATION_EXPORT double YPFoundationVersionNumber;
FOUNDATION_EXPORT const unsigned char YPFoundationVersionString[];

