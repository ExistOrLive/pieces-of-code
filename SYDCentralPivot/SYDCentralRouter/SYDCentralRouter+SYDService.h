//
//  SYDCentralRouter+SYDService.h
//  SYDServiceSDK
//
//  Created by panzhengwei on 2019/1/11.
//  Copyright © 2019年 YueMingXingXi. All rights reserved.
//

#import "SYDCentralRouter.h"

@interface SYDCentralRouter (SYDService)

- (id) sendMessageToService:(const NSString *) serviceKey withSEL:(SEL) message withPara:(NSArray *) paramArray isInstanceMessage:(BOOL) isInstanceMessage;



@end
