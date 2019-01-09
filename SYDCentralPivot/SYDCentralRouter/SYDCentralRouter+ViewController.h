//
//  SYDCentralRouter+ViewController.h
//  SYDServiceSDK
//
//  Created by panzhengwei on 2019/1/9.
//  Copyright © 2019年 YueMingXingXi. All rights reserved.
//

#import "SYDCentralRouter.h"

@interface SYDCentralRouter (ViewController)

- (void) enterViewController:(const NSString *) viewControllerKey withViewControllerConfig:(id) config withParam:(NSDictionary *) paramDic;

@end
