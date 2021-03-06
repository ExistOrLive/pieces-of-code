//
//  ZMRefreshManager.h
//  iCenter
//
//  Created by panzhengwei on 2018/9/26.
//  Copyright © 2018年 MyApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol ZMRefreshManagerDelegate <NSObject>

- (void) ZMRefreshIsDragUp:(BOOL) isDragUp refreshView:(UIView *) refreshView;

@end


@interface ZMRefreshManager : NSObject

@property(nonatomic,weak) id<ZMRefreshManagerDelegate> delegate;


#pragma mark - 初始化和释放

- (instancetype) initWithScrollView:(UIScrollView *) scrollView addHeaderView:(BOOL) addHeaderView addFooterView:(BOOL)addFooterView;

- (void) freeHeaderView;
- (void) freeFooterView;
- (void) free;

#pragma mark - 管理刷新状态

// 刷新结束
- (void) setHeaderViewRefreshEnd;

- (void) setFooterViewRefreshEnd;

// 全部刷新结束
- (void) setHeaderViewNoMoreFresh;

- (void) setFooterViewNoMoreFresh;


@end
