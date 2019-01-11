//
//  SYDCentralFactory+SYDService.h
//  SYDServiceSDK
//
//  Created by panzhengwei on 2019/1/9.
//  Copyright © 2019年 YueMingXingXi. All rights reserved.
//

#import "SYDCentralFactory.h"

@interface SYDCentralFactory (SYDService)

- (id) getSYDServiceBean:(const NSString *) serviceKey;

@end
