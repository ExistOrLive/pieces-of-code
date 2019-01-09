//
//  UIViewController+SYDRouter.h
//  SYDServiceSDK
//
//  Created by panzhengwei on 2019/1/7.
//  Copyright © 2019年 YueMingXingXi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYDCentralRouterModel.h"


@interface UIViewController (SYDRouter)

+ (void) enterViewControllerWithViewControllerConfig:(id) config withParam:(NSDictionary *) paramDic;

+ (UIViewController *) getOneViewController;

@end
