//
//  NSObject+M9BlockKVO.h
//  M9Dev
//
//  Created by MingLQ on 2016-09-08.
//  Copyright © 2016 MingLQ <minglq.9@gmail.com>. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id BJCFBlockKVObserver;

typedef void (^BJCFKVOBlock)(id old, id new);

@interface NSObject (BJCFBlockKVO)

/**
 *  @see - [NSNotificationCenter addObserverForName:object:queue:usingBlock:]
 */
- (BJCFBlockKVObserver)bjcf_addKVObserverForKeyPath:(NSString *)keyPath
                                         usingBlock:(BJCFKVOBlock)block;
- (BJCFBlockKVObserver)bjcf_addKVObserverForKeyPath:(NSString *)keyPath
                                            options:(NSKeyValueObservingOptions)options
                                         usingBlock:(BJCFKVOBlock)block;
- (void)bjcf_removeKVObserver:(NSObject *)observer;

@end
