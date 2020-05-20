//
//  ZJJCarouselView.h
//  ZJJCarouselViewExample
//
//  Created by 天空吸引我 on 2018/5/3.
//  Copyright © 2018年 天空吸引我. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TKShowButtonBlock)(UIButton *carouselButton,NSInteger index);

@interface TKCarouselView : UIView

+ (instancetype)managerWithFrame:(CGRect)frame;

//MARK:- 轮播图参数设置
/**是否开启自动轮播（默认是开启状态）*/
@property (nonatomic,assign) BOOL isAutoScroll;
/**轮播间隔时间（默认为2秒）*/
@property (nonatomic,assign) NSTimeInterval intervalTime;
/**当imageCount==0时才能生效*/
@property (nonatomic,strong) UIImageView *placeholderImageView;

/// 刷新或者开启轮播图
/// @param imageCount 需要轮播的数量
/// @param showImageBlock UIButton的回调，用户给button设置图片通过index
/// @param imgClicked 点击回调
- (void)reloadCarouselViewWithImageCount:(NSUInteger)imageCount showImageBlock:(TKShowButtonBlock)showImageBlock imgClicked:(void(^)(NSInteger index))imgClicked;

//MARK:- UIPageControl相关设置
@property (nonatomic,assign) CGSize currentSize;//当前页的size
@property (nonatomic,assign) CGSize otherSize;//除了当前页的size

@end
