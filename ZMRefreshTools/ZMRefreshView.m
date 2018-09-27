//
//  ZMRefreshView.m
//  iCenter
//
//  Created by panzhengwei on 2018/9/25.
//  Copyright © 2018年 MyApp. All rights reserved.
//

#import "ZMRefreshView.h"
#import "ZMRefreshConfig.h"

@interface ZMRefreshView()

@property(nonatomic,strong) UILabel * title;

@property(nonatomic,strong) UIActivityIndicatorView * indicatorView;

@end


@implementation ZMRefreshView


- (instancetype) initWithFrame:(CGRect)frame IsHeaderView:(BOOL) isHeaderView
{
    if(self = [self initWithFrame:frame])
    {
        _isHeadView = isHeaderView;
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, (ZMRefreshViewHeight - 20) / 2, frame.size.width, 20)];
        _title.font = [UIFont systemFontOfSize:12];
        _title.textAlignment = NSTextAlignmentCenter;
        if(_isHeadView)
        {
            _title.text = DropDownSeeMore;
        }
        else
        {
            _title.text = DropUpSeeMore;
        }
        _title.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = CGRectMake(30, (ZMRefreshViewHeight - 20) / 2, 20, 20);
        
        [self addSubview:_title];
        [self addSubview:_indicatorView];
        
    }
    
    return self;
}



- (void) updateRefreshState:(ZMRefreshState) state
{
    switch(state)
    {
        case ZMRefreshState_Init:
        case ZMRefreshState_Drag:
        {
            _title.text = DropDownSeeMore;
            [_indicatorView setHidden:YES];
        }
            break;
        case ZMRefreshState_willRefreshing:
            break;
        case ZMRefreshState_Refreshing:
        {
            _title.text = Loading;
            [_indicatorView setHidden:NO];
            [_indicatorView startAnimating];
        }
        break;
        case ZMRefreshState_NoMoreRefresh:
        {
            _title.text = LoadFinished;
            [_indicatorView setHidden:YES];
        }
    }
    
    _refreshState = state;
}

@end
