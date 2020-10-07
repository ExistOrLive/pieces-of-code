
//
//  ZMReadWriteLock.m
//  iCenter
//
//  Created by zhumeng on 2018/11/1.
//  Copyright © 2018年 MyApp. All rights reserved.
//

/**
 * 读写锁的设计
 * 1、 写操作互斥，因此写操作之间需要一个互斥锁 writeLock
 * 2、 读操作之间不需要互斥， 因此读操作之间不需要互斥锁
 * 3、 读的时候不可以写，写的时候不可以读 ， 需要记录 读者数量 readCount
 *
*/


#import "ZMReadWriteLock.h"

@interface ZMReadWriteLock(){
    dispatch_semaphore_t writeLock;
    
    dispatch_semaphore_t synclock;
    
    int readCount;
}

@end

@implementation ZMReadWriteLock

- (instancetype) init
{
    if(self = [super init]){
        
        writeLock = dispatch_semaphore_create(1);
        
        synclock = dispatch_semaphore_create(1);
        
        readCount = 0;
    }
    
    return self;
}

- (void) lockReadLock{
   
    dispatch_semaphore_wait(synclock,DISPATCH_TIME_FOREVER);
    
    readCount ++;
    
    if(readCount == 1){                                               // 如果是第一个读者，请求写锁
        dispatch_semaphore_wait(writeLock, DISPATCH_TIME_FOREVER);
    }
    
    dispatch_semaphore_signal(synclock);
}

- (void) unLockReadLock{
    
    dispatch_semaphore_wait(synclock,DISPATCH_TIME_FOREVER);
    
    readCount --;
    
    if(readCount == 0){
        dispatch_semaphore_signal(writeLock);                         // 如果是最后一个读者，释放写锁
    }
    
    dispatch_semaphore_signal(synclock);
}


- (void) lockWriteLock{
    dispatch_semaphore_wait(writeLock, DISPATCH_TIME_FOREVER);
}


- (void) unLockWriteLock{
    dispatch_semaphore_signal(writeLock);
}





@end



@interface ZMReadWriteLock2(){
    
    dispatch_semaphore_t mutexReadCount;            // 保证reacCount的互斥访问
    
    dispatch_semaphore_t mutexWriteCount;           // 保证writeCount的互斥访问     每个共享变量由不同的互斥锁保证互斥，避免占有并等待，循环等待导致死锁的问题
    
    dispatch_semaphore_t r;
    
    dispatch_semaphore_t w;                         // r，w 用于 读写之间的同步
    
    dispatch_semaphore_t mutextPriority;            // 在优先锁释放前，若来了读者，写者会P(r) 而 读者因为优先锁没有释放，无法P(r)
    
    
    int readCount;
    int writeCount;
    
}

@end

@implementation ZMReadWriteLock2

- (instancetype) init
{
    if(self = [super init]){
        
        mutexReadCount = dispatch_semaphore_create(1);
        mutexWriteCount = dispatch_semaphore_create(1);
        r = dispatch_semaphore_create(1);
        w = dispatch_semaphore_create(1);
        mutextPriority = dispatch_semaphore_create(1);
        
        readCount = 0;
        writeCount = 0;
    }
    
    return self;
}

- (void) lockReadLock{
   
    dispatch_semaphore_wait(mutextPriority,DISPATCH_TIME_FOREVER);
    
    dispatch_semaphore_wait(r,DISPATCH_TIME_FOREVER);
    
    dispatch_semaphore_wait(mutexReadCount,DISPATCH_TIME_FOREVER);
    
    readCount ++;
    
    if(readCount == 1){
        dispatch_semaphore_wait(w, DISPATCH_TIME_FOREVER);                // 与写操作互斥
    }
    
    dispatch_semaphore_signal(mutexReadCount);
    
    dispatch_semaphore_signal(r);
    
    dispatch_semaphore_signal(mutextPriority);
}

- (void) unLockReadLock{
    
    dispatch_semaphore_wait(mutexReadCount,DISPATCH_TIME_FOREVER);
    
    readCount --;
    
    if(readCount == 0){
        dispatch_semaphore_signal(w);                         // 如果是最后一个读者，释放写锁
    }
    
    dispatch_semaphore_signal(mutexReadCount);
}


- (void) lockWriteLock{
    
    dispatch_semaphore_wait(mutexWriteCount, DISPATCH_TIME_FOREVER);
    
    writeCount++;
    
    if(writeCount == 1){
        dispatch_semaphore_wait(r, DISPATCH_TIME_FOREVER);                  // 开始写，阻止后续的读操作
    }
    
    dispatch_semaphore_signal(mutexWriteCount);
    
    
    dispatch_semaphore_wait(w, DISPATCH_TIME_FOREVER);                      // 保证读的互斥

}


- (void) unLockWriteLock{
    
    dispatch_semaphore_signal(w);

    dispatch_semaphore_wait(mutexWriteCount, DISPATCH_TIME_FOREVER);
    
    writeCount--;
    
    if(writeCount == 0){
        dispatch_semaphore_signal(r);               // 放行后续的读操作
    }
    
    dispatch_semaphore_signal(mutexWriteCount);
}





@end

