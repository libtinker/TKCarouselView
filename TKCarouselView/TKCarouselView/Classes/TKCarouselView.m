//
//  ZJJCarouselView.m
//  ZJJCarouselViewExample
//
//  Created by 天空吸引我 on 2018/5/3.
//  Copyright © 2018年 天空吸引我. All rights reserved.
//

#import "TKCarouselView.h"

static const int imageBtnCount = 3;

@interface TKPageControl : UIPageControl
@property (nonatomic,assign) CGSize currentPageSize;//当前页的size
@property (nonatomic,assign) CGSize otherPageSize;//除了当前页的size
@end

@implementation TKPageControl

- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];

    if (_currentPageSize.width==0||_currentPageSize.height==0||_otherPageSize.width==0||_otherPageSize.height==0) {
        return;
    }
    for (NSUInteger subviewIndex = 0; subviewIndex < self.subviews.count; subviewIndex++) {
        UIView *subview = [self.subviews objectAtIndex:subviewIndex];
        subview.layer.cornerRadius  = 2;
        if (subviewIndex == currentPage) {
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, _currentPageSize.width, _currentPageSize.height)];
        }else{
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, _otherPageSize.width, _otherPageSize.height)];
        }
    }
}

@end

@interface TKCarouselView() <UIScrollViewDelegate>
@property (nonatomic, strong) TKPageControl *pageControl;
@property (nonatomic, strong) UIScrollView*scrollView;
@property (nonatomic, assign) NSUInteger imageCount;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic,copy) TKShowButtonBlock showImageBlock;
@property (nonatomic,copy) void(^carouselViewdidSelectBlock) (NSInteger index);/**轮播图点击事件*/

@end

@implementation TKCarouselView

+ (instancetype)managerWithFrame:(CGRect)frame {
    TKCarouselView *carouselView = [[TKCarouselView alloc] initWithFrame:frame];
    carouselView.isAutoScroll = YES;
    carouselView.intervalTime = 3.0f;
    return carouselView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _intervalTime = 3.0;
        _isAutoScroll = YES;
    }
    return self;
}

- (void)reloadCarouselViewWithImageCount:(NSUInteger)imageCount showImageBlock:(TKShowButtonBlock)showImageBlock imgClicked:(void(^)(NSInteger index))imgClicked {
    self.placeholderImageView.hidden = imageCount == 0 ? NO : YES;

    _imageCount = imageCount;
    _carouselViewdidSelectBlock = imgClicked;
    _showImageBlock = showImageBlock;

    self.scrollView.hidden = imageCount >0 ? NO : YES;
    for (int i = 0;i < imageBtnCount; i++) {
        UIButton *imageBtn = [[UIButton alloc] init];
        [self.scrollView addSubview:imageBtn];
    }

    self.pageControl.hidden = imageCount>1 ? NO : YES;
    self.pageControl.numberOfPages = imageCount;
    self.pageControl.currentPage = 0;

    [self setContent];
    [self startTimer];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    _scrollView.contentSize = CGSizeMake(width*imageBtnCount, 0);
    
    for (int i=0; i<_scrollView.subviews.count; i++) {
        UIButton *imageBtn = self.scrollView.subviews[i];
        imageBtn.frame = CGRectMake(i*width, 0, width, height);
        [imageBtn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    //设置contentOffset,显示最中间的图片
    self.scrollView.contentOffset = CGPointMake(width, 0);
}


//设置显示内容
- (void)setContent{
    for (int i=0; i<self.scrollView.subviews.count; i++) {
        NSInteger index = _pageControl.currentPage;
        UIButton *imgBtn = self.scrollView.subviews[i];
        if (i == 0) {
            index--;
        }else if (i == 2){
            index++;
        }
        if (index<0) {
            index = _pageControl.numberOfPages-1;
        }else if (index == _pageControl.numberOfPages) {
            index = 0;
        }
        imgBtn.tag = index;

        if (self.showImageBlock) self.showImageBlock(imgBtn,index);
    }
}

//状态改变之后更新显示内容
- (void)updateContent {
    CGFloat width = self.bounds.size.width;
    [self setContent];
    self.scrollView.contentOffset = CGPointMake(width, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = 0;
    //用来拿最小偏移量
    CGFloat minDistance = MAXFLOAT;
    
    for (int i=0; i<self.scrollView.subviews.count; i++) {
        UIButton *imagBtn = self.scrollView.subviews[i];
        CGFloat distance = 0;
        distance = ABS(imagBtn.frame.origin.x - scrollView.contentOffset.x);
        if (distance<minDistance) {
            minDistance = distance;
            page = imagBtn.tag;
        }
    }
    _pageControl.currentPage = page;
}

//开始拖拽的时候停止计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

//结束拖拽的时候开始定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

//结束拖拽的时候更新image内容
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateContent];
}

//scroll滚动动画结束的时候更新image内容
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateContent];
}

#pragma mark - 定时器
//开始计时器
- (void)startTimer {
    [self stopTimer];
    if (_isAutoScroll) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_intervalTime target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}

//停止计时器
- (void)stopTimer {
    if (self.timer) {
        //结束计时
        [self.timer invalidate];
        //计时器被系统强引用，必须手动释放
        self.timer = nil;
    }
}

//通过改变contentOffset * 2换到下一张图片
- (void)nextImage {
    CGFloat width = self.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(2 * width, 0) animated:YES];
}

- (void)imageBtnClicked:(UIButton *)button {
    NSInteger index = button.tag;
    if (_carouselViewdidSelectBlock) {
        _carouselViewdidSelectBlock(index);
    }
}

//MARK:- getter -

- (UIImageView *)placeholderImageView {
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _placeholderImageView.backgroundColor = UIColor.lightGrayColor;
        _placeholderImageView.userInteractionEnabled = YES;
        [self addSubview:_placeholderImageView];
    }
    return _placeholderImageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (TKPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[TKPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.3];
        _pageControl.frame = CGRectMake(0, self.bounds.size.height - 20, self.frame.size.width, 20);
        [self addSubview:_pageControl];
    }
    _pageControl.currentPageSize = self.currentSize;
    _pageControl.otherPageSize = self.otherSize;
    return _pageControl;
}

@end
