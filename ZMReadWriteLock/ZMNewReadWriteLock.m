//
//  ZMNewReadWhiteLock.m
//  Test
//
//  Created by panzhengwei on 2019/4/30.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import "ZMNewReadWriteLock.h"
#import <pthread.h>

/**
 *  读写锁的实现
 *  1、 写操作之间互斥
 *  2、 读操作之间不互斥
 *  3、 读操作 与 写操作之间互斥
 *  4、 设置两个条件变量 isWrite 和 readCount
 **/

/**
 *  tip:
 *  条件变量是利用线程间共享的全局变量进行同步的一种机制，
 *  主要包括两个动作：一个线程等待"条件变量的条件成立"而挂起；
 *  另一个线程使"条件成立"（给出条件成立信号）。
 *  (1)  为了防止竞争，条件变量的使用总是和一个互斥锁结合在一起；条件变量的使用必须在临界区
 *  (2)  判断条件变量，需要使用while(),而不是if; 这样可以让线程唤醒后重新判断条件
 *  (3)  避免阻塞的线程不被唤醒，使用pthread_cond_broadcast
 *
 **/



@interface ZMNewReadWriteLock()
{
    pthread_mutex_t mutex;
    pthread_cond_t  condition;

    int readCount;
    BOOL isWrite;
    
}

@end


@implementation ZMNewReadWriteLock

- (instancetype) init
{
    if(self = [super init])
    {
        pthread_mutex_init(&mutex,NULL);
        
        pthread_cond_init(&condition, NULL);
    }
    
    return self;
}

- (void) lockReadLock
{
    pthread_mutex_lock(&mutex);
    
    while(isWrite)
    {
        pthread_cond_wait(&condition, &mutex);
    }

    readCount ++;
    
    pthread_mutex_unlock(&mutex);
}



- (void) unLockReadLock
{
    pthread_mutex_lock(&mutex);
    
    readCount --;
    
    if(readCount == 0)
    {
        pthread_cond_broadcast(&condition);         // 唤醒所有在
    }
    
    pthread_mutex_unlock(&mutex);
}


- (void) lockWriteLock
{
    pthread_mutex_lock(&mutex);
    
    while(readCount > 0 || isWrite)                                         // 使用while，令写线程在阻塞唤醒后，重新判断条件变量
    {
        pthread_cond_wait(&condition, &mutex);
    }
    
    isWrite = YES;
    
    pthread_mutex_unlock(&mutex);
}


- (void) unLockWriteLock
{
    pthread_mutex_lock(&mutex);

    isWrite = NO;
    
    pthread_cond_broadcast(&condition);
    
    pthread_mutex_unlock(&mutex);

}



@end
