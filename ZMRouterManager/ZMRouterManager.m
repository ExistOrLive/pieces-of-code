
//
//  ZMRouterManager.m
//  iCenter
//
//  Created by panzhengwei on 2018/10/30.
//  Copyright © 2018年 MyApp. All rights reserved.
//

#import "ZMRouterManager.h"
#import "ZMRouterSupport.h"

@implementation ZMRouterManager

- (void) openURL:(NSString *) urlStr
{
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSString * schema = [url scheme];
    
    if([ZMRouterPrefix isEqualToString:schema])
    {
        
    }
    
    
}


- (void) dealWithZMRouterURL:(NSString *) urlStr
{
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSString * schema = [url scheme];
    
    
}


@end
