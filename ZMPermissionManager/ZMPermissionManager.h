//
//  ZMPermissionManager.h
//  iCenter
//
//  Created by panzhengwei on 2018/10/23.
//  Copyright © 2018年 MyApp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    ZMPermissionRequestType_PhotoLibrary,
    ZMPermissionRequestType_Camera,
    ZMPermissionRequestType_Microphone,
    ZMPermissionRequestType_Contact
}ZMPermissionRequestType;





@interface ZMPermissionManager : NSObject

/**
 *  创建单例
 **/
+ (ZMPermissionManager *) sharedInstance;


/**
 *  申请相应的权限
 *  @param requestType  申请的权限类型
 *  @param agreeBlock   申请成功回调
 *  @param deniedBlock  拒绝申请的回调
 **/

- (BOOL) requestPermissionWithType:(ZMPermissionRequestType) requestType WithAgreeBlock:(void(^)(void)) agreeBlock withDeniedBlock:(void(^)(void)) deniedBlock;


@end
