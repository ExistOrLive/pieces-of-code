//
//  ZMNewReadWhiteLock.h
//  Test
//
//  Created by panzhengwei on 2019/4/30.
//  Copyright © 2019年 ZTE. All rights reserved.
//

#import <Foundation/Foundation.h>

//  基于互斥量和条件变量实现的读者写者模型 读写锁   读者优先

@interface ZMNewReadWriteLock1 : NSObject

- (void) lockReadLock;
- (void) unLockReadLock;


- (void) lockWriteLock;
- (void) unLockWriteLock;


@end


//  基于互斥量和条件变量实现的读者写者模型 读写锁   写者优先

@interface ZMNewReadWriteLock2 : NSObject

- (void) lockReadLock;
- (void) unLockReadLock;


- (void) lockWriteLock;
- (void) unLockWriteLock;


@end
