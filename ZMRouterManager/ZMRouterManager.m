
//
//  ZMRouterManager.m
//  iCenter
//
//  Created by zhumeng on 2018/10/30.
//  Copyright © 2018年 MyApp. All rights reserved.
//

#import "ZMRouterManager.h"
#import "ZMRouterSupport.h"


@implementation ZMRouterManager

+ (ZMRouterManager *) sharedInstance
{
    static ZMRouterManager * singleInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!singleInstance)
        {
            singleInstance = [[ZMRouterManager alloc] init];
        }
    });
    
    return singleInstance;
}


- (void) openURL:(NSString *) urlStr
{
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSString * schema = [url scheme];
    
    if([ZMRouterPrefix isEqualToString:schema])
    {
        [self dealWithZMRouterURL:urlStr];
    }
    
    
}


- (void) dealWithZMRouterURL:(NSString *) urlStr
{
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSString * schema = [url scheme];
    
    
}


@end
