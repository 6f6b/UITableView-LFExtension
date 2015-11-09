//
//  UITableView+LFExtension.h
//  LFRefreshLoading
//
//  Created by qianfeng on 15/9/27.
//  Copyright (c) 2015年 LF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFHeadRefresh.h"
#import "LFFooterLoading.h"


@interface UITableView (LFExtension)

- (void)headRefreshViewWithRefreshBlock:(RefreshBlock)block;
- (void)setHeadTitle:(NSString *)title forState:(HeaderViewStatus)status;
- (void)footerViewWithLoadingBlock:(loadingBlock)block;
- (void)setFootTitle:(NSString *)title forState:(FooterViewStatus)status;
- (void)stopAnimation;

@end
