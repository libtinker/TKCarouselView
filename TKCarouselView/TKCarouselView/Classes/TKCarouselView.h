//
//  ZJJCarouselView.h
//  ZJJCarouselViewExample
//
//  Created by libtinker on 2018/5/3.
//  Copyright © 2018年 libtinker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TKItemAtIndexBlock)(UIImageView *imageView,NSInteger index);

@interface TKCarouselView : UIView

//MARK:- CarouselView parameter setting

// Whether to turn on automatic rotoasting (the default is to turn on, it must be imageCount>1, otherwise rotoasting is meaningless)
@property (nonatomic,assign) BOOL isAutoScroll;
//Rotation interval (3 seconds by default)）
@property (nonatomic,assign) NSTimeInterval intervalTime;
// It takes effect when imageCount==0
@property (nonatomic,strong) UIImageView *placeholderImageView;

//MARK:- UIPageControl Related Settings (do not set the default to dots)

//Current page dot size
@property (nonatomic,assign) CGSize currentSize;
//Except for the size of the dots on the current page
@property (nonatomic,assign) CGSize otherSize;

/// reload (Must be implemented)
/// @param imageCount imageCount
/// @param itemAtIndexBlock A view displayed on the screen
/// @param imageClickedBlock The view is clicked
- (void)reloadImageCount:(NSUInteger)imageCount itemAtIndexBlock:(TKItemAtIndexBlock)itemAtIndexBlock imageClickedBlock:(void(^)(NSInteger index))imageClickedBlock;
@end
