//
//  LFHeadRefresh.h
//  LFRefreshLoading
//
//  Created by qianfeng on 15/9/27.
//  Copyright (c) 2015年 LF. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RefreshBlock)();
typedef enum {
    HeaderViewStatusBeginDrag, //拖拽读取更多
    HeaderViewStatusDragging,  //松开读取更多
    HeaderViewStatusRefreshing,   //正在读取
} HeaderViewStatus;

@interface LFHeadRefresh : UIView
+ (id)headRefreshViewWithRefreshBlock:(RefreshBlock)block;
+ (id)headRefresh;
- (void)setHeadTitle:(NSString *)title forState:(HeaderViewStatus)status;
- (void)stopAnimation;
@end
