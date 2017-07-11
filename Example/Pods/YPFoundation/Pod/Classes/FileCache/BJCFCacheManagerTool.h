//
//  CacheManagerTool.h
//  BJEducation_student
//
//  Created by Mrlu-bjhl on 15/1/5.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  本地文件缓存 NSTemporaryDirectory
 */
@interface BJCFCacheManagerTool : NSObject

#pragma cache NSTemporaryDirectory
- (void)clearCacheWithSuccess:(void(^)(void))success;
- (void)clearCacheWithDir:(NSString *)dirName success:(void(^)(void))success;

#pragma mark - 文件大小
/**
 *  sync 同步
 *
 *  @return
 */
- (CGFloat)getCacheFileSize;
/**
 *
 * Async 异步
 *  @param finish
 */
- (void)getCacheFileSize:(void(^)(CGFloat size))finish;

@end
