//
//  NSObject+M9BlockKVO.m
//  M9Dev
//
//  Created by MingLQ on 2016-09-08.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+BJCFBlockKVO.h"

@interface BJCFBlockKVOObserver : NSObject

@property (nonatomic, copy) BJCFKVOBlock block;

@end

@implementation BJCFBlockKVOObserver

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
    if (self.block) self.block(change[NSKeyValueChangeOldKey], change[NSKeyValueChangeNewKey]);
}

@end

#pragma mark -

@implementation NSObject (BJCFBlockKVO)

static void *BJCFBlockKVOObservers = &BJCFBlockKVOObservers;

- (BJCFBlockKVObserver)bjcf_addKVObserverForKeyPath:(NSString *)keyPath
                                         usingBlock:(BJCFKVOBlock)block {
    return [self bjcf_addKVObserverForKeyPath:keyPath
                                      options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                   usingBlock:block];
}

- (BJCFBlockKVObserver)bjcf_addKVObserverForKeyPath:(NSString *)keyPath
                                            options:(NSKeyValueObservingOptions)options
                                         usingBlock:(BJCFKVOBlock)block {
    BJCFBlockKVOObserver *observer = [BJCFBlockKVOObserver new];
    observer.block = block;
    
    NSMutableArray *observers = objc_getAssociatedObject(self, BJCFBlockKVOObservers);
    if (!observers) {
        observers = [NSMutableArray new];
        objc_setAssociatedObject(self, BJCFBlockKVOObservers, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject:observer];
    
    [self addObserver:observer
           forKeyPath:keyPath
              options:options
              context:NULL];
    return observer;
}

- (void)bjcf_removeKVObserver:(NSObject *)observer {
    NSMutableArray *observers = objc_getAssociatedObject(self, BJCFBlockKVOObservers);
    [observers removeObject:observer];
}

@end
