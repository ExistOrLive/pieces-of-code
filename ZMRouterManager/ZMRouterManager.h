//
//  ZMRouterManager.h
//  iCenter
//
//  Created by zhumeng on 2018/10/30.
//  Copyright © 2018年 MyApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMRouterManager : NSObject

+ (ZMRouterManager *) sharedInstance;

- (void) openURL:(NSString *) urlStr;

@end
