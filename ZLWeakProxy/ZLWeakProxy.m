//
//  ZLWeakProxy.m
//  Test1
//
//  Created by 朱猛 on 2020/6/4.
//  Copyright © 2020 zm. All rights reserved.
//

#import "ZLWeakProxy.h"

@interface ZLWeakProxy()

@end


@implementation ZLWeakProxy

- (instancetype) initWithObject:(id)object {
    _object = object;
    return self;
}

+ (instancetype) proxyWithObject:(id)object {
    return [[self alloc] initWithObject:object];
}


#pragma mark - msg forward

- (id)forwardingTargetForSelector:(SEL)selector {
    return _object;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [_object methodSignatureForSelector:sel];
}

#pragma mark - protocol NSObject

- (BOOL)isEqual:(id)object{
    return [_object isEqual:object];
}

- (NSUInteger) hash {
    return [_object hash];
}

- (Class) class {
    return [_object class];
}

- (Class)superclass {
    return [_object superclass];
}

- (BOOL)isKindOfClass:(Class)aClass{
    return [_object isKindOfClass:aClass];
}
- (BOOL)isMemberOfClass:(Class)aClass{
    return [_object isMemberOfClass:aClass];
}
- (BOOL)conformsToProtocol:(Protocol *)aProtocol{
    return [_object conformsToProtocol:aProtocol];
}

- (BOOL) respondsToSelector:(SEL)aSelector {
    return [_object respondsToSelector:aSelector];
}

- (BOOL) isProxy {
    return YES;
}

- (NSString *)description {
    return [_object description];
}

- (NSString *)debugDescription {
    return [_object debugDescription];
}
@end
