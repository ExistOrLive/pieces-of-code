//
//  ZMBlockQueue.m
//  Test
//
//  Created by panzhengwei on 2019/4/30.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import "ZMNewBlockQueue.h"

/**
 * dispatch_semaphore_t 和 c语言中的信号量机制 sem_t 相似
 * 提供了在多线程之间互斥访问有限个共享资源的机制
 *
 * 在我看来， 它们相当于一个简化版的pthread_cond_t,
 * (1) dispatch_semaphore_t 和 sem_t 只能够对整数值进行判断，而决定线程是否阻塞和唤醒; pthread_cond_t 能够进行复杂的条件判断(多个条件变量综合)
 * (2) dispatch_semaphore_t 和 sem_t 自动实现了对于条件变量互斥访问; pthread_cond_t 需要一个pthread_mutex_t配合
 * (3) dispatch_semaphore_t 和 sem_t 一次只能唤醒一个线程；pthread_cond_t可以唤醒多个线程，但是要再次进行条件判断
 */

#define DefaultCapacity 16

@interface ZMNewBlockQueue()
{
    dispatch_semaphore_t syncLock;
    
    dispatch_semaphore_t emptyConditionLock;
    
    dispatch_semaphore_t enoughConditionLock;
    
}

@property(nonatomic,strong) NSMutableArray * array;

@property(nonatomic,assign) NSUInteger capacity;

@end


@implementation ZMNewBlockQueue

- (instancetype) initWithCapacity:(NSUInteger) capacity
{
    if(self = [super init])
    {
        syncLock = dispatch_semaphore_create(1);
        emptyConditionLock = dispatch_semaphore_create(0);
        enoughConditionLock = dispatch_semaphore_create(capacity);
        
        _array = [[NSMutableArray alloc] initWithCapacity:capacity];
        _capacity = capacity;
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
    
    dispatch_semaphore_wait(syncLock, DISPATCH_TIME_FOREVER);
    
    tmpSize = [self.array count];
    
    dispatch_semaphore_signal(syncLock);
    
    return tmpSize;
}


- (void) put:(id) object
{
    if(!object){
        return;
    }
    
    dispatch_semaphore_wait(enoughConditionLock, DISPATCH_TIME_FOREVER);           // 当缓冲区满，等待
        
    dispatch_semaphore_wait(syncLock, DISPATCH_TIME_FOREVER);                      // 保证互斥
    
    [_array insertObject:object atIndex:0];
    
    dispatch_semaphore_signal(syncLock);
    
    NSLog(@"Thread[%@] put end %@",[NSThread currentThread],object);
    
    dispatch_semaphore_signal(emptyConditionLock);
}

- (id) take
{
    id object = nil;
    
    dispatch_semaphore_wait(emptyConditionLock, DISPATCH_TIME_FOREVER);          // 当缓冲区为空，等待
    
    
    dispatch_semaphore_wait(syncLock, DISPATCH_TIME_FOREVER);
    
    object = [_array lastObject];
    
    [_array removeLastObject];
    
    dispatch_semaphore_signal(syncLock);
    
    NSLog(@"Thread[%@] take end %@",[NSThread currentThread],object);
    
    dispatch_semaphore_signal(enoughConditionLock);
    
    return object;
    
}

@end


