//
//  SYDCentralRouterModel.h
//  SYDServiceSDK
//
//  Created by panzhengwei on 2019/1/7.
//  Copyright © 2019年 YueMingXingXi. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

typedef enum
{
    SYDCentralRouterModelType_UIViewController,
    SYDCentralRouterModelType_Service,
    SYDCentralRouterModelType_Other,
    
}SYDCentralRouterModelType;


@interface SYDCentralRouterModel : NSObject

@property(nonatomic,strong) NSString * modelKey;

@property(nonatomic,assign) SYDCentralRouterModelType modelType;

@property(nonatomic,strong) Class cla;

@property(nonatomic,assign) BOOL isSingle;                                      // 是否为单例类

@property(nonatomic,strong) NSString * singletonMethodStr;                      // 单例方法；仅当isSingle为YES有效

@property(nonatomic,strong) id singleton;                                       // 单例；仅当isSingle为YES有效

@end



#pragma mark -

@interface SYDCentralRouterViewControllerConfig : NSObject

@property(nonatomic,assign) BOOL isNavigated;

@property(nonatomic,strong) UIViewController * sourceViewController;

@property(nonatomic,assign) BOOL hidesBottomBarWhenPushed;

@end
