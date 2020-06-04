//
//  ZLWeakProxy.h
//  Test1
//
//  Created by 朱猛 on 2020/6/4.
//  Copyright © 2020 zm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLWeakProxy : NSProxy

@property(nonatomic, weak, readonly) id object;

- (instancetype) initWithObject:(id) object;

+ (instancetype) proxyWithObject:(id) object;

@end

NS_ASSUME_NONNULL_END
