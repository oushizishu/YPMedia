//
//  NSArray+BJCF.m
//  Pods
//
//  Created by Randy on 16/2/19.
//
//

#import "NSArray+BJCF.h"

@implementation NSArray (BJCF)
- (NSString *)BJCF_separateStringWithStr:(NSString *)str;
{
    NSString *sepStr = str;
    if (sepStr == nil) {
        sepStr = @"";
    }
    NSMutableString *mutStr = [[NSMutableString alloc] initWithCapacity:0];
    for (NSString *oneStr in self) {
        if ([oneStr isKindOfClass:[NSString class]]) {
            [mutStr appendString:oneStr];
            if (oneStr != self.lastObject) {
                [mutStr appendString:sepStr];
            }
        }
        else if ([oneStr isKindOfClass:[NSNumber class]])
        {
            [mutStr appendFormat:@"%@",oneStr];
            if (oneStr != self.lastObject) {
                [mutStr appendString:sepStr];
            }
        }
        else
        {
            NSAssert1(0, @"必须是NSString和NSNumber类型 %s", __FUNCTION__);
        }
    }
    return mutStr;
}

- (id)BJCF_objectAtIndex:(NSUInteger)index;
{
    return [self BJCF_containsIndex:index] ? [self objectAtIndex:index] : nil;
}

- (BOOL)BJCF_containsIndex:(NSUInteger)index {
    return index < [self count];
}

- (NSArray *)BJCF_arrayByRemoveObject:(id)object;
{
    NSMutableArray *array = [self mutableCopy];
    [array removeObject:object];
    return [array copy];
}

- (NSArray *)BJCF_arrayByRemoveObjectsInArray:(NSArray *)otherArray;
{
    NSMutableArray *array = [self mutableCopy];
    [array removeObjectsInArray:otherArray];
    return [array copy];
}

@end

@implementation NSMutableArray (BJCF)

- (void)BJCF_addObjectNonNil:(id)object
{
    if (object) {
        [self addObject:object];
    }
}

- (void)BJCF_removeObjectAtIndex:(NSUInteger)index{
    if (index < [self count]) {
        [self removeObjectAtIndex:index];
    }
}

- (void)BJCF_insertObjectNonNil:(id)anObject atIndex:(NSUInteger)index{
    if (anObject && index <= [self count]) {
        [self insertObject:anObject atIndex:index];
    }
}

- (BOOL)BJCF_replaceObjectAtIndex:(NSUInteger)index withObjectNonNil:(id)anObject {
    if (anObject && index < [self count]) {
        [self replaceObjectAtIndex:index withObject:anObject];
        return YES;
    }
    return NO;
}

@end
