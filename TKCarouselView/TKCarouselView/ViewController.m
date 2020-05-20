//
//  ViewController.m
//  TKCarouselView
//
//  Created by 天空吸引我 on 2020/5/20.
//  Copyright © 2020 libtinker. All rights reserved.
//

#import "ViewController.h"
#import "TKCarouselView.h"

@interface ViewController ()
@property (nonatomic,strong)  TKCarouselView *carouselView;
@property (nonatomic,strong) NSMutableDictionary *imageDict;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageDict = [NSMutableDictionary dictionary];

    [self testTKCarouselView];
}

- (void)testTKCarouselView {
    NSArray *array = @[@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3658587479,3162190896&fm=26&gp=0.jpg",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1322896087,2736086242&fm=26&gp=0.jpg",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2716219330,3814054151&fm=26&gp=0.jpg",@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2776433555,1185570728&fm=26&gp=0.jpg"];

    _carouselView = [TKCarouselView managerWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width/2)];
    _carouselView.currentSize = CGSizeMake(10, 4);
    _carouselView.otherSize = CGSizeMake(6, 4);
    _carouselView.placeholderImageView.image = [UIImage imageNamed:@"placeholderImage.jpg"];
    [self.view addSubview:_carouselView];

    NSLog(@"---------------------");
    dispatch_queue_t queue = dispatch_queue_create("libtinker", DISPATCH_QUEUE_CONCURRENT);
//    array = @[];//用于测试placeholderImageView
    //这里要使用你喜欢的加载图片的框架
    [_carouselView reloadCarouselViewWithImageCount:array.count showImageBlock:^(UIButton *carouselButton, NSInteger index) {
        //推荐使用sd等网络框架
        
      __block UIImage *image;
      __block NSData *data = self.imageDict[[NSString stringWithFormat:@"%@",@(index)]];
        if (data == nil) {
            image = [UIImage imageNamed:@"placeholderImage.jpg"];
            [carouselButton setImage:image forState:UIControlStateNormal];
            [carouselButton setImage:image forState:UIControlStateSelected];
            [carouselButton setImage:image forState:UIControlStateHighlighted];
            dispatch_async(queue, ^{
                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:array[index]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        [self.imageDict setObject:data forKey:[NSString stringWithFormat:@"%@",@(index)]];
                        image = [UIImage imageWithData:data];
                    }else {
                        [self.imageDict removeObjectForKey:[NSString stringWithFormat:@"%@",@(index)]];
                    }
                    [carouselButton setImage:image forState:UIControlStateNormal];
                    [carouselButton setImage:image forState:UIControlStateSelected];
                    [carouselButton setImage:image forState:UIControlStateHighlighted];
                });
            });

        }else {
            image = [UIImage imageWithData:data];
            [carouselButton setImage:image forState:UIControlStateNormal];
            [carouselButton setImage:image forState:UIControlStateSelected];
            [carouselButton setImage:image forState:UIControlStateHighlighted];
        }

    } imgClicked:^(NSInteger index) {

    }];
}

@end
