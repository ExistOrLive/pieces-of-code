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
        singleInstance.configProperty = @{[NSNumber numberWithInt:ZMPermissionRequestType_Camera]:@"requestPhotoLibraryUsagePermissionWithAgreeBlock:withDeniedBlock:"};
    });
    
    return singleInstance;
}


- (BOOL) requestPermissionWithType:(ZMPermissionRequestType) requestType WithAgreeBlock:(void(^)(void)) agreeBlock withDeniedBlock:(void(^)(void)) deniedBlock
{
    NSString * selectorStr = [self.configProperty objectForKey:[NSNumber numberWithInt:requestType]];
    SEL selectorObject = NSSelectorFromString(selectorStr);
    
    if([self respondsToSelector:selectorObject])
    {
       id result = [self performSelector:selectorObject withObject:agreeBlock withObject:deniedBlock];
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
