//
//  SYDCentralFactory.m
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/9.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "SYDCentralFactory.h"



#import <objc/runtime.h>

@interface SYDCentralFactory()

@property(nonatomic,strong) NSMutableDictionary * sydCentralModelMap;

@end

@implementation SYDCentralFactory

#pragma mark - 单例

+ (instancetype) sharedInstance
{
    static SYDCentralFactory * centralFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        centralFactory = [[SYDCentralFactory alloc] init];
    });
    
    return centralFactory;
}


- (instancetype) init
{
    if(self = [super init])
    {
        NSString * centralRouterConfigPath = [[NSBundle mainBundle] pathForResource:@"SYDCenteralFactoryConfig" ofType:@"plist"];
        NSDictionary * centralRouterConfig = [[NSDictionary alloc] initWithContentsOfFile:centralRouterConfigPath];
        
        if(centralRouterConfig)
        {
            _sydCentralModelMap = [[NSMutableDictionary alloc] init];
//            _viewControllerModelMapCache = [[NSMutableDictionary alloc] init];
//            _serviceModelMapCache = [[NSMutableDictionary alloc] init];
//            _otherMapCache= [[NSMutableDictionary alloc] init];
            
            [centralRouterConfig enumerateKeysAndObjectsUsingBlock:^(id key,id value,BOOL * stop)
             {
                 NSString * modelKey = key;
                 NSDictionary * modelValue = value;
                 
                 NSString * classString = [modelValue objectForKey:@"class"];
                 Class cla = NSClassFromString(classString);
                 
                 if(cla)
                 {
                     SYDCentralRouterModel * model = nil;
                     if((SYDCentralRouterModelType)modelKey == SYDCentralRouterModelType_Service)
                     {
                         SYDCentralRouterServiceModel * tmpModel = [[SYDCentralRouterServiceModel alloc] init];
                         NSDictionary * queueInfo = [modelValue objectForKey:@"asyncMethods"];
         
                         if(queueInfo)
                         {
                             [tmpModel setQueueTag:[queueInfo objectForKey:@"queueTag"]];
                             [tmpModel setAsyncMethodArray:[queueInfo objectForKey:@"methods"]];
                         }
                     }
                     else
                     {
                         model = [[SYDCentralRouterModel alloc] init];
                     }
                  
                     [model setModelKey:modelKey];
                     [model setCla:cla];
                     [model setIsSingle:[[modelValue objectForKey:@"isSingle"] boolValue]];
                     [model setSingletonMethodStr:[modelValue objectForKey:@"singleMethod"]];
                     [_sydCentralModelMap setObject:model forKey:modelKey];
                   
                 }
                 else
                 {
                     LOG_DEBUGGING_NS(@"SYDCentralFactory_init: class for [%@] not exist",modelKey);
                 }
             }];
        }
    }
    
    return self;
}


- (SYDCentralRouterModel *) getCentralRouterModel:(const NSString *) beanKey
{
    return [self.sydCentralModelMap objectForKey:beanKey];
}


- (id) getCommonBean:(const NSString *) beanKey
{
    SYDCentralRouterModel * model = [self.sydCentralModelMap objectForKey:beanKey];
    
    id commomBean = nil;
    
    if(model)
    {
        if(model.isSingle)
        {
            commomBean = [model singleton];
        
            if(!commomBean)
            {
                commomBean = [self getSingleton:beanKey];
                
                if(!commomBean)
                {
                     LOG_DEBUGGING_NS(@"SYDCentralFactory_getCommonBean: create singleton for [%@] failed",beanKey);
                }
            }
            
        }
        else
        {
            commomBean = class_createInstance([model cla], 0);
        }
    }
    else
    {
        LOG_DEBUGGING_NS(@"SYDCentralFactory_getCommonBean: SYDCentralRouterModel for [%@] is not exist",beanKey);
    }
    
    return commomBean;
}


- (id) getCommonBean:(const NSString *) beanKey withInjectParam:(NSDictionary *) param
{
    id commonBean = [self getCommonBean:beanKey];
    
    if(commonBean)
    {
        [param enumerateKeysAndObjectsUsingBlock:^(id key,id value,BOOL * stop)
         {
             NSString * tmpKey = key;
             
             @try
             {
                 [commonBean setValue:value forKey:tmpKey];
             }
             @catch(NSException * exception)
             {
                 LOG_DEBUGGING_NS(@"SYDCentralFactory_getCommonBeanWithInjectParam: value for key[%@] not exist,exception[%@]",beanKey,exception);
             }
             
         }];
    }
    
    return commonBean;
}


- (id) getSingleton:(const NSString *) beanKey
{
    SYDCentralRouterModel * model = [self.sydCentralModelMap objectForKey:beanKey];
    
    id singleton = nil;
    
    if(model)
    {
        if(model.isSingle && model.singletonMethodStr)
        {
            SEL singleMethodSel = NSSelectorFromString(model.singletonMethodStr);
            Method singletonMethod = class_getClassMethod(model.cla,singleMethodSel);
            id(*singletonMethodIMP)(id,SEL) = (id(*)(id,SEL))method_getImplementation(singletonMethod);
            
            if(singletonMethodIMP)
            {
                singleton = singletonMethodIMP(model.cla,singleMethodSel);
                [model setSingleton:singleton];
            }
            else
            {
                LOG_DEBUGGING_NS(@"SYDCentralFactory_getSingleton: singleton method for [%@] not exist",beanKey);
            }
        }
        else
        {
            LOG_DEBUGGING_NS(@"SYDCentralFactory_getSingleton: SYDCentralRouterModel for [%@] is not singleton",beanKey);
        }
    }
    else
    {
        LOG_DEBUGGING_NS(@"SYDCentralFactory_getSingleton: SYDCentralRouterModel for [%@] is not exist",beanKey);
    }
    
    return singleton;
}


@end
