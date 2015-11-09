//
//  LFFooterLoading.m
//  LFRefreshLoading
//
//  Created by qianfeng on 15/9/27.
//  Copyright (c) 2015年 LF. All rights reserved.
//

#import "LFFooterLoading.h"

@interface LFFooterLoading ()
//{
//    loadingBlock loadingBlock;
//}

@property (nonatomic,assign) FooterViewStatus status;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,weak) UILabel *labelLoading;
@property (nonatomic,weak) UIImageView *image;
@property (nonatomic,weak) UILabel *labelDrag;

@property (nonatomic,copy) NSString *tittleForStatusBeginDrag;
@property (nonatomic,copy) NSString *tittleForStatusDragging;
@property (nonatomic,copy) NSString *tittleForStatusLoading;
@end

@implementation LFFooterLoading
- (id)init{
    if (self = [super init]) {
        self.tittleForStatusBeginDrag = @"拖拽加载";
        self.tittleForStatusDragging = @"松手加载";
        self.tittleForStatusLoading = @"正在加载";
    }
    return self;
}

+ (id)footerViewWithLoadingBlock:(loadingBlock)block{
   
    LFFooterLoading *footerView = [LFFooterLoading footerView];
    [footerView setLoadingBlock:block];
    footerView.loadingBlock = block;
    NSLog(@"block%@",block);
    NSLog(@"BLock%@",footerView.loadingBlock);
    return footerView;
}

+ (id)footerView{
    static LFFooterLoading *footerView;
    if (footerView==nil) {
        footerView = [[LFFooterLoading alloc] init];
    }
    return footerView;
}

- (void)setFootTitle:(NSString *)title forState:(FooterViewStatus)status{
    if (status==FooterViewStatusBeginDrag) {
        _tittleForStatusBeginDrag = title;
    }
    if (status==FooterViewStatusDragging) {
        _tittleForStatusDragging = title;
    }
    if (status==FooterViewStatusLoading) {
        _tittleForStatusLoading = title;
    }
}

//- (void)setLoadingBlock:(loadingBlock)loadingBlock{
//
//}

- (void)setStatus:(FooterViewStatus)status{
    _status = status;
    if (status==FooterViewStatusBeginDrag) {
        self.labelDrag.text=_tittleForStatusBeginDrag;
        self.labelDrag.hidden = NO;
        self.labelLoading.hidden = YES;
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else if (status==FooterViewStatusDragging) {
        self.labelDrag.text = _tittleForStatusDragging;
    }
    else if (status==FooterViewStatusLoading) {
        self.labelDrag.hidden = YES;
        self.labelLoading.hidden = NO;
        NSLog(@"开始加载");
        self.labelLoading.text = _tittleForStatusLoading;
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
//        NSLog(@"block%@",self.loadingBlock);
        if (self.loadingBlock) {
            self.loadingBlock();
        }
        
    }
}


- (void)dealloc{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)stopAnimation{
    [self.labelDrag removeFromSuperview];
    [self.labelLoading removeFromSuperview];
    self.status = FooterViewStatusBeginDrag;
}


- (UILabel *)labelDrag{
    if (_labelDrag==nil) {
        UILabel * la =[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.5-40, 0, 80, 50)];
        _labelDrag.textAlignment = NSTextAlignmentCenter;
        _labelDrag = la;
        _labelDrag.font = [UIFont systemFontOfSize:17];
        [self addSubview:_labelDrag];
    }
    return _labelDrag;
}

- (UILabel *)labelLoading{
    if (_labelLoading==nil) {
        UILabel * la =[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.5-40, 0, 80, 50)];
        _labelLoading.textAlignment = NSTextAlignmentCenter;
        _labelLoading = la;
        _labelLoading.font = [UIFont systemFontOfSize:17];
        [self addSubview:_labelLoading];
    }
    return _labelLoading;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    UIScrollView *scrollView =(UIScrollView *)newSuperview;
    if (_scrollView==nil) {
        _scrollView = scrollView;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:nil];
    }
    if (scrollView.contentSize.height<scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, scrollView.frame.size.width, 50);
        NSLog(@"%@",NSStringFromCGRect(self.frame));
        
    }
    self.frame = CGRectMake(0, scrollView.contentSize.height, scrollView.contentSize.width, 50);
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self willMoveToSuperview:_scrollView];
    float MaxOffSet;
    if (_scrollView.frame.size.height>_scrollView.contentSize.height) {
        MaxOffSet = 50;
    }
    {
        MaxOffSet = self.scrollView.contentSize.height-self.scrollView.frame.size.height;
    }
    
    if (self.scrollView.isDragging&&self.status!=FooterViewStatusLoading) {
        if (self.scrollView.contentOffset.y>MaxOffSet&&self.scrollView.contentOffset.y<MaxOffSet+50) {
            self.status = FooterViewStatusBeginDrag;
        }
        if (self.scrollView.contentOffset.y>MaxOffSet+50) {
            self.status = FooterViewStatusDragging;
        }
    }
    else if (!self.scrollView.isDragging){
        if (self.status==FooterViewStatusDragging) {
            self.status = FooterViewStatusLoading;
        }
    }
    
}

@end
