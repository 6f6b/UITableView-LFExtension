//
//  LFFooterLoading.h
//  LFRefreshLoading
//
//  Created by qianfeng on 15/9/27.
//  Copyright (c) 2015年 LF. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    FooterViewStatusBeginDrag, //拖拽读取更多
    FooterViewStatusDragging,  //松开读取更多
    FooterViewStatusLoading,   //正在读取
} FooterViewStatus;

typedef void (^loadingBlock)();
@interface LFFooterLoading : UIView
@property (nonatomic,copy) loadingBlock loadingBlock;

+ (id)footerViewWithLoadingBlock:(loadingBlock)block;
+ (id)footerView;
- (void)setFootTitle:(NSString *)title forState:(FooterViewStatus)status;
- (void)stopAnimation;
@end
