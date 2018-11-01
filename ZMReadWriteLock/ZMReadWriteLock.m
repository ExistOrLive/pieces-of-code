
//
//  ZMReadWriteLock.m
//  iCenter
//
//  Created by panzhengwei on 2018/11/1.
//  Copyright © 2018年 MyApp. All rights reserved.
//

#import "ZMReadWriteLock.h"

#define ReadLockArraySyncLock @"ReadLockArraySyncLock"

@interface ZMReadWriteLock()

@property(nonatomic, strong) NSCondition * writeLock;

@property(nonatomic, strong) NSMutableArray * readLocks;


@property(nonatomic,assign) int readCount;

@property(atomic,assign) BOOL isWrite;

@end

@implementation ZMReadWriteLock

- (instancetype) init
{
    if(self = [super init])
    {
        _writeLock = [[NSCondition alloc] init];
        _readLocks = [[NSMutableArray alloc] init];
        
        _readCount = 0;
        _isWrite = 0;
    }
    
    return self;
}

- (NSCondition *) lockReadLock
{
    NSCondition * readLock = [[NSCondition alloc] init];
    
    [readLock lock];
    @synchronized(ReadLockArraySyncLock)
    {
        [self.readLocks addObject:readLock];
       
    }

    if(self.isWrite)
    {
        [readLock wait];
    }
    
    self.readCount ++;
    
    return readLock;
}

- (void) unLockReadLock:(NSCondition *) readLock
{
 
    self.readCount --;

    if(self.readCount == 0)
    {
        [self.writeLock signal];
    }
    
    @synchronized(ReadLockArraySyncLock)
    {
        [self.readLocks removeObject:readLock];
        
    }
    [readLock unlock];
}


- (void) lockWriteLock
{
    [self.writeLock lock];
    
    self.isWrite = YES;
    
    if(self.readCount > 0)
    {
        [self.writeLock wait];
    }
}


- (void) unLockWriteLock
{
    self.isWrite = NO;
    
    @synchronized(ReadLockArraySyncLock)
    {
        for(NSCondition * condition in self.readLocks)
        {
            [condition signal];
        }
    }
    
    [self.writeLock unlock];
}





@end
