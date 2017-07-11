//
//  CacheManagerTool.m
//  BJEducation_student
//
//  Created by Mrlu-bjhl on 15/1/5.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "BJCFCacheManagerTool.h"
#import "BJCFFileManagerTool.h"

@implementation BJCFCacheManagerTool

#pragma mark - all
//TODO 测试此接口
- (void)clearCacheWithSuccess:(void(^)(void))success
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *tmpDir = NSTemporaryDirectory();
        NSArray *list = [BJCFFileManagerTool filePathsWithDirPath:tmpDir];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (NSString *path in list) {
            NSError *error = nil;
            if([fileManager removeItemAtPath:path error:&error])
            {
                NSLog(@"%@下文件删除成功",path);
            }
            else
            {
                NSLog(@"%@下文件删除失败:error:%@",path,error.description);
            }
        }

       dispatch_async(dispatch_get_main_queue(), ^{
           if (success) {
               success();
           }
       });
    });
}

//TODO测试
- (void)clearCacheWithDir:(NSString *)dirName success:(void(^)(void))success;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *tmpDir = NSTemporaryDirectory();
        tmpDir = [tmpDir stringByAppendingPathComponent:dirName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        if([fileManager removeItemAtPath:tmpDir error:&error])
        {
            NSLog(@"%@下文件删除成功",tmpDir);
        }
        else
        {
            NSLog(@"%@下文件删除失败:error:%@",tmpDir,error.description);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success();
            }
        });
    });
}

- (CGFloat)getCacheFileSize
{
    CGFloat fileSize = 0;
    
    NSString *tmpDir = NSTemporaryDirectory();
    
    fileSize += [BJCFFileManagerTool folderSizeAtPath:tmpDir];
    
    return fileSize;
}

- (void)getCacheFileSize:(void (^)(CGFloat))finish{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        CGFloat fileSize = 0;
        
        NSString *tmpDir = NSTemporaryDirectory();
        
        fileSize += [BJCFFileManagerTool folderSizeAtPath:tmpDir];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            if (finish) {
                finish(fileSize);
            }
        });
    });
}

@end
