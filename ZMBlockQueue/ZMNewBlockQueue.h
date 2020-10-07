//
//  ZMBlockQueue.h
//  Test
//
//  Created by panzhengwei on 2019/4/30.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  ZMBlockQueue 阻塞队列 生产者，消费者模型
 *  基于信号量(dispatch_semaphore_t)实现 实现的管程
 **/


@interface ZMNewBlockQueue : NSObject

@property(nonatomic,readonly) NSUInteger capacity;

@property(nonatomic,readonly) NSUInteger size;

- (instancetype) initWithCapacity:(NSUInteger) capacity;

- (void) put:(id) object;

- (id) take;

@end
