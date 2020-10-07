
//
//  ZMBlockQueue.m
//  Test
//
//  Created by zhumeng on 2018/11/22.
//  Copyright © 2018年 ZM. All rights reserved.
//

/**
 *
 * 阻塞队列描述
 * 1.   生产者线程 向共享缓存区中插入元素； 消费者线程从共享缓存区中取出元素
 * 2、 当缓存区为空时，消费者线程等待 缓存区满时，生产者线程等待
 * 3、 当生产者线程向缓存队列中插入一个元素，需要唤醒一个等待的消费者线程
 * 4、 当消费者线程从缓存队列中取出一个元素，需要唤醒一个等待的生产者线程
 *
 * 阻塞队列实现
 * 一个NSMutableArray 保存元素
 * 一个互斥锁 pthread_mutex_t 保证对管程的互斥访问
 * 两个条件锁 ： 一个当缓冲区满，阻塞生产者线程； 当缓冲区空，阻塞消费者线程
 **/

#import "ZMBlockQueue.h"
#include <pthread.h>

#define DefaultCapacity 16


@interface ZMBlockQueue()
{
    pthread_mutex_t syncMutex;               // 同步锁，用于对数组的互斥访问
    
    pthread_cond_t putCondition;             // 条件锁，在数组容量满时，wait
    
    pthread_cond_t takeCondition;            // 条件锁， 在数组为空时， wait    
}

@property(nonatomic,strong) NSMutableArray * queue;

@end


@implementation ZMBlockQueue

- (instancetype) initWithCapacity:(NSUInteger) capacity{
    
    if(self = [super init]){
        
        _capacity = capacity;
        _queue = [[NSMutableArray alloc] init];
    
        /**
         *
         * 设置为默认互斥锁，当一个线程获取到锁后，其余线程必须在请求锁时，形成一个等待队列；当释放锁后，其余线程按优先级取锁； 默认不能够嵌套
         **/
        pthread_mutex_init(&syncMutex,NULL);
        
        pthread_cond_init(&putCondition, NULL);
        
        pthread_cond_init(&takeCondition, NULL); 
    }
    
    return self;
}


- (instancetype) init{
   
    if(self = [self initWithCapacity:DefaultCapacity]){
        
    }
    return self;
}

- (NSUInteger) size{
    
    NSUInteger tmpSize = 0;
    
    pthread_mutex_lock(&syncMutex);
    
    tmpSize = [self.queue count];
    
    pthread_mutex_unlock(&syncMutex);
    
    return tmpSize;
}


- (void) put:(id) value{
    
    if(!value){
        return;
    }
    
    pthread_mutex_lock(&syncMutex);                                     // 保证对管程的互斥访问
    
    while([self.queue count] >= self.capacity){
        pthread_cond_wait(&putCondition, &syncMutex);                   // 当缓冲区满，阻塞生产者线程
    }
            
    [self.queue insertObject:value atIndex:0];
        
    NSLog(@"Thread[%@] put end %@",[NSThread currentThread],value);
    
    pthread_cond_signal(&takeCondition);                                // 插入一个元素，唤醒一个消费者线程
    
    pthread_mutex_unlock(&syncMutex);                                   // 退出管程

}



- (id) take{
    id value = nil;
    
    pthread_mutex_lock(&syncMutex);                                       // 保证对管程的互斥访问
    
    while([self.queue count] <= 0){                                          // 当缓冲区空，阻塞消费者线程
        pthread_cond_wait(&takeCondition, &syncMutex);
    }
        
    value = [self.queue lastObject];
    [self.queue removeLastObject];
        
    NSLog(@"Thread[%@] take %@",[NSThread currentThread],value);
    
    pthread_cond_signal(&putCondition);                                   // 取出一个元素，唤醒一个生产者线程
    
    pthread_mutex_unlock(&syncMutex);                                     // 离开管程
    
    return value;
}


- (void) dealloc{
    pthread_mutex_destroy(&syncMutex);
    pthread_cond_destroy(&putCondition);
    pthread_cond_destroy(&takeCondition);
}




@end
