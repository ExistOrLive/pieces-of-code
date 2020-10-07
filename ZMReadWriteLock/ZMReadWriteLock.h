//
//  ZMReadWriteLock.h
//  iCenter
//
//  Created by panzhengwei on 2018/11/1.
//  Copyright © 2018年 MyApp. All rights reserved.
//

#import <Foundation/Foundation.h>

//  基于信号量实现的读者写者模型 读写锁   读者优先

@interface ZMReadWriteLock : NSObject

- (void) lockReadLock;
- (void) unLockReadLock;

- (void) lockWriteLock;
- (void) unLockWriteLock;


@end


@interface ZMReadWriteLock2 : NSObject

- (void) lockReadLock;
- (void) unLockReadLock;

- (void) lockWriteLock;
- (void) unLockWriteLock;


@end
