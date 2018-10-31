//
//  ZMRouterInstanceFactory.m
//  TestDemo
//
//  Created by 朱猛 on 2018/10/31.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#import "ZMRouterInstanceFactory.h"
#import "ZMRouterInstanceFactorySupport.h"

@interface ZMRouterInstanceFactory()

@property(nonatomic, strong) NSString * factoryConfigFilePath;

@property(nonatomic, strong) NSDictionary * factoryConfigDic;

@property(nonatomic, strong) NSMutableDictionary * singleInstanceDic;

@end

@implementation ZMRouterInstanceFactory

+ (instancetype) sharedInstance
{
    static ZMRouterInstanceFactory * singleInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!singleInstance)
        {
            singleInstance = [[ZMRouterInstanceFactory alloc] initWithConfigFilePath:ZMRouterInstanceFactoryPath];
        }
    });
    
    return singleInstance;
}



- (instancetype) initWithConfigFilePath:(NSString *) filePath
{
    if(!filePath)
    {
        NSLog(@"ZMRouterInstanceFactory: init : filePath is nil");
        return nil;
    }
    
    if(self = [super init])
    {
        NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        
        if(!dic)
        {
            NSLog(@"ZMRouterInstanceFactory: init : configFile format error,configDic is nil");
            return nil;
        }
        
        _factoryConfigFilePath = filePath;
        _factoryConfigDic = dic;
        
    }
    
    return self;
    
}




@end
