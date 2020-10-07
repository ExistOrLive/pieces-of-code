//
//  ZMBlockQueue.h
//  Test
//
//  Created by zhumeng on 2018/11/22.
//  Copyright © 2018年 ZM. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  ZMBlockQueue 阻塞队列 生产者，消费者模型
 *  基于互斥量 pthread_mutex_t 和条件变量 pthread_cond_t  实现的管程
 **/

@interface ZMBlockQueue : NSObject

@property(nonatomic,readonly) NSUInteger capacity;

@property(nonatomic,readonly) NSUInteger size;

- (instancetype) initWithCapacity:(NSUInteger) capacity;

- (void) put:(id) value;

- (id) take;


@end
