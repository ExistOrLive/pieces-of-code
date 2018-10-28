//
//  ZMPermissionManager.m
//  iCenter
//
//  Created by panzhengwei on 2018/10/23.
//  Copyright © 2018年 MyApp. All rights reserved.
//

#import "ZMPermissionManager.h"

#pragma mark - 相册使用权限
#import <Photos/Photos.h>

@interface ZMPermissionManager()

@property(nonatomic,strong) NSDictionary * configProperty;

@end


@implementation ZMPermissionManager

+ (ZMPermissionManager *) sharedInstance
{
    static ZMPermissionManager * singleInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleInstance = [[ZMPermissionManager alloc] init];
        singleInstance.configProperty = @{[NSNumber numberWithInt:ZMPermissionRequestType_PhotoLibrary]:@"requestPhotoLibraryUsagePermissionWithAgreeBlock:withDeniedBlock:"};
    });
    
    return singleInstance;
}


- (BOOL) requestPermissionWithType:(ZMPermissionRequestType) requestType WithAgreeBlock:(void(^)(void)) agreeBlock withDeniedBlock:(void(^)(void)) deniedBlock
{
    NSString * selectorStr = [self.configProperty objectForKey:[NSNumber numberWithInt:requestType]];
    SEL selectorObject = NSSelectorFromString(selectorStr);
    
    if([self respondsToSelector:selectorObject])
    {
        /**
         * 获取SEL对应的IMP实现方法调用
         * 1、 适应多个参数的情况
         * 2、 适应返回值为基本数据类型和void的情况；使用performSelector时返回值为基本数据类型可能会闪退
         * 3、 当方法需要频繁调用时，使用函数指针，效率会更高
         **/
        IMP methodIMP = [self methodForSelector:selectorObject];
        BOOL(* funtionPointer)(ZMPermissionManager * ,SEL,void(^)(void),void(^)(void)) = (BOOL(*)(ZMPermissionManager * ,SEL,void(^)(void),void(^)(void)))methodIMP;
        return funtionPointer(self,selectorObject,agreeBlock,deniedBlock);
    }

    return NO;
}


- (BOOL) requestPhotoLibraryUsagePermissionWithAgreeBlock:(void(^)(void)) agreeBlock withDeniedBlock:(void(^)(void)) deniedBlock
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if(PHAuthorizationStatusDenied == status ||
       PHAuthorizationStatusRestricted == status)
    {
        if(deniedBlock)
        {
            deniedBlock();
        }
        
        return NO;
    }
    else if(PHAuthorizationStatusAuthorized == status)
    {
        if(agreeBlock)
        {
            agreeBlock();
        }
          return YES;
    }
    
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
     {
        if(PHAuthorizationStatusAuthorized == status)
        {
            if(agreeBlock)
            {
                agreeBlock();
            }
        }
         
     }];
    
    
    return NO;
}



@end
