//
//  NSArray+BJCF.h
//  Pods
//
//  Created by Randy on 16/2/19.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (BJCF)

- (NSString *)BJCF_separateStringWithStr:(NSString *)str DEPRECATED_MSG_ATTRIBUTE("非通用需求，各端自行实现，并且这个方法名 ...");
- (id)BJCF_objectAtIndex:(NSUInteger)index;
- (BOOL)BJCF_containsIndex:(NSUInteger)index;
- (NSArray *)BJCF_arrayByRemoveObject:(id)object;
- (NSArray *)BJCF_arrayByRemoveObjectsInArray:(NSArray *)array;

@end

@interface NSMutableArray (BJCF)

- (void)BJCF_addObjectNonNil:(id)object;
- (void)BJCF_removeObjectAtIndex:(NSUInteger)index;
- (void)BJCF_insertObjectNonNil:(id)anObject atIndex:(NSUInteger)index;
- (BOOL)BJCF_replaceObjectAtIndex:(NSUInteger)index withObjectNonNil:(id)anObject;

@end
