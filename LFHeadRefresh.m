//
//  LFHeadRefresh.m
//  LFRefreshLoading
//
//  Created by qianfeng on 15/9/27.
//  Copyright (c) 2015年 LF. All rights reserved.
//

#import "LFHeadRefresh.h"
@interface LFHeadRefresh ()
@property (nonatomic,strong) RefreshBlock refreshBlock;
@property (nonatomic,assign) HeaderViewStatus status;
@property (nonatomic,weak) UILabel *labelRefresh;
@property (nonatomic,copy) NSString *tittleForStatusBeginDrag;
@property (nonatomic,copy) NSString *tittleForStatusDragging;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,weak) UIImageView *image;
@property (nonatomic,weak) UILabel *labelDrag;
@property (nonatomic,copy) NSString *tittleForStatusRefreshing;
@end
@implementation LFHeadRefresh
- (id)init{
    if (self = [super init]) {
        self.tittleForStatusBeginDrag = @"拖拽刷新";
        self.tittleForStatusDragging = @"松手刷新";
        self.tittleForStatusRefreshing = @"正在刷新";
    }
    return self;
}

+ (id)headRefreshViewWithRefreshBlock:(RefreshBlock)block{
    LFHeadRefresh *headView = [LFHeadRefresh headRefresh];
    headView.refreshBlock = block;
    return headView;
}

+ (id)headRefresh{
    static LFHeadRefresh *headerView;
    if (headerView==nil) {
        headerView = [[LFHeadRefresh alloc] init];
    }
    return headerView;
}

- (void)setHeadTitle:(NSString *)title forState:(HeaderViewStatus)status{
    if (status==HeaderViewStatusBeginDrag) {
        _tittleForStatusBeginDrag = title;
    }
    if (status==HeaderViewStatusDragging) {
        _tittleForStatusDragging = title;
    }
    if (status==HeaderViewStatusRefreshing) {
        _tittleForStatusRefreshing = title;
    }
}

- (void)setStatus:(HeaderViewStatus)status{
    _status = status;
    if (status==HeaderViewStatusBeginDrag) {
        self.labelDrag.text=_tittleForStatusBeginDrag;
        self.labelDrag.hidden = NO;
        self.labelLoading.hidden = YES;
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else if (status==HeaderViewStatusDragging) {
        self.labelDrag.text = _tittleForStatusDragging;
    }
    else if (status==HeaderViewStatusRefreshing) {
        self.labelDrag.hidden = YES;
        self.labelLoading.hidden = NO;
        NSLog(@"开始加载");
        self.labelLoading.text = _tittleForStatusRefreshing;
        self.scrollView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }
}


- (void)dealloc{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)stopAnimation{
    [self.labelDrag removeFromSuperview];
    [self.labelLoading removeFromSuperview];
    self.status = HeaderViewStatusBeginDrag;
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
    if (_labelRefresh==nil) {
        UILabel * la =[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.5-40, 0,80, 50)];
        _labelRefresh.textAlignment = NSTextAlignmentCenter;
        _labelRefresh = la;
        _labelRefresh.font = [UIFont systemFontOfSize:17];
        [self addSubview:_labelRefresh];
    }
    return _labelRefresh;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    UIScrollView *scrollView =(UIScrollView *)newSuperview;
    if (_scrollView==nil) {
        _scrollView = scrollView;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:nil];
    }
    self.frame = CGRectMake(0, -50, scrollView.contentSize.width, 50);
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self willMoveToSuperview:_scrollView];
    float MaxOffSet = -50;
    
    if (self.scrollView.isDragging&&self.status!=HeaderViewStatusRefreshing) {
        if (self.scrollView.contentOffset.y>MaxOffSet&&self.scrollView.contentOffset.y<MaxOffSet+50) {
            self.status = HeaderViewStatusBeginDrag;
        }
        if (self.scrollView.contentOffset.y<MaxOffSet) {
            self.status = HeaderViewStatusDragging;
        }
    }
    else if (!self.scrollView.isDragging){
        if (self.status==HeaderViewStatusDragging) {
            self.status = HeaderViewStatusRefreshing;
        }
    }
    
}

@end
