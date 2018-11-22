
//
//  ZMBlockQueue.m
//  Test
//
//  Created by zhumeng on 2018/11/22.
//  Copyright © 2018年 ZM. All rights reserved.
//

/**
 * 阻塞队列实现原理
 * 1、 首先需要一个互斥锁实现消费者线程和生产者线程对缓存队列的互斥访问
 * 2、 另外 当缓存队列为空时，消费者线程等待 缓存队列满时，生产者线程等待
 * 3、 当生产者线程向缓存队列中插入一个元素，需要唤醒等待的消费者线程
 * 4、 当消费者线程从缓存队列中取出一个元素，需要唤醒等待的生产者线程
 *
 *  queation：
 *  当生产者线程插入一个元素后，会唤醒等待的一个消费者线程A，然后释放互斥锁；
 *  这是如果存在一个因为互斥锁而阻塞的消费者线程B，就会与消费者线程A竞争互斥锁，
 *  如果A获取互斥锁，则流程正常
 *  如果B获取互斥锁，就会导致A之后进入临界区代码时，出现错误，因为A已经在等待判断了条件，唤醒后不再判断，直接从缓存队列中取出元素，此时可能取出nil
 *
 **/

#import "ZMBlockQueue.h"
#include <pthread.h>

#define DefaultCapacity 16


@interface ZMBlockQueue()
{
    pthread_mutex_t mutex;
    pthread_cond_t putCondition;
    pthread_cond_t takeCondition;
    pthread_mutexattr_t mutexattr;
}

@property(nonatomic,strong) NSMutableArray * queue;

@end


@implementation ZMBlockQueue

- (instancetype) initWithCapacity:(NSUInteger) capacity
{
    if(self = [super init])
    {
        _POSIX_THREAD_PRIORITY_SCHEDULING
        _capacity = capacity;
        _queue = [[NSMutableArray alloc] init];
    
        /**
         *
         * 设置为默认互斥锁，当一个线程获取到锁后，其余线程必须在请求锁时，形成一个等待对列；当释放锁后，其余线程按优先级取锁； 默认不能够嵌套
         **/
        pthread_mutex_init(&mutex,NULL);
        
        pthread_cond_init(&putCondition, NULL);
        pthread_cond_init(&takeCondition, NULL);
        
    }
    
    return self;
}


- (instancetype) init
{
    if(self = [self initWithCapacity:DefaultCapacity])
    {
        
    }
    
    return self;
}

- (NSUInteger) size
{
    NSUInteger tmpSize = 0;
    
    pthread_mutex_lock(&mutex);
    
    tmpSize = [self.queue count];
    
    pthread_mutex_unlock(&mutex);
    
    return tmpSize;
}


- (void) put:(id) value
{
    if(!value)
    {
        return;
    }
    
    pthread_mutex_lock(&mutex);
    
    NSLog(@"Thread[%@] put %@ start",[NSThread currentThread],value);
    
    if([self.queue count] >= self.capacity)
    {
        NSLog(@"Thread[%@] put %@ wait",[NSThread currentThread],value);
        
        pthread_cond_wait(&putCondition, &mutex);
        
        NSLog(@"Thread[%@] put %@ restart",[NSThread currentThread],value);
    }
    
    [self.queue insertObject:value atIndex:0];
    
     NSLog(@"Thread[%@] count %ld",[NSThread currentThread],[self.queue count]);
    
   
    pthread_cond_signal(&takeCondition);
    
  
    
    NSLog(@"Thread[%@] put %@ end",[NSThread currentThread],value);
    
    pthread_mutex_unlock(&mutex);
}



- (id) take
{
    id value = nil;
    
    pthread_mutex_lock(&mutex);
    
    NSLog(@"Thread[%@] take start",[NSThread currentThread]);
    
    if([self.queue count] <= 0)
    {
        NSLog(@"Thread[%@] take wait",[NSThread currentThread]);
        
        pthread_cond_wait(&takeCondition, &mutex);
        
        NSLog(@"Thread[%@] take restart",[NSThread currentThread]);
    }
    
    value = [self.queue lastObject];
    [self.queue removeLastObject];
    
    pthread_cond_signal(&putCondition);
    

    NSLog(@"Thread[%@] take %@ end",[NSThread currentThread],value);
        
    pthread_mutex_unlock(&mutex);
    
    
    return value;
}







@end
