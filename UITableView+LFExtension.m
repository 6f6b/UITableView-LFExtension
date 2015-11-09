//
//  UITableView+LFExtension.m
//  LFRefreshLoading
//
//  Created by qianfeng on 15/9/27.
//  Copyright (c) 2015年 LF. All rights reserved.
//

#import "UITableView+LFExtension.h"

@implementation UITableView (LFExtension)

- (void)stopAnimation{
    LFHeadRefresh *headerRefresh = [LFHeadRefresh headRefresh];
    LFFooterLoading *footerLoading = [LFFooterLoading footerView];
    [headerRefresh stopAnimation];
    [footerLoading stopAnimation];
}

- (void)setFootTitle:(NSString *)title forState:(FooterViewStatus)status{
    LFFooterLoading *footerLoading = [LFFooterLoading footerView];
    [footerLoading setFootTitle:title forState:status];
}

- (void)setHeadTitle:(NSString *)title forState:(HeaderViewStatus)status{
    LFHeadRefresh *headerRefresh = [LFHeadRefresh headRefresh];
    [headerRefresh setHeadTitle:title forState:status];
}


- (void)headRefreshViewWithRefreshBlock:(RefreshBlock)block{
    LFHeadRefresh *headRefresh = [LFHeadRefresh headRefreshViewWithRefreshBlock:block];
    [self addSubview:headRefresh];
}

- (void)footerViewWithLoadingBlock:(loadingBlock)block{
    LFFooterLoading *footerLoading = [LFFooterLoading footerViewWithLoadingBlock:block];
    [self addSubview:footerLoading];
}

@end
