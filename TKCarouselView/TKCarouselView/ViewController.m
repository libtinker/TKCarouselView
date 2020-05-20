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
    NSArray *array = @[@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1035996821,2050333048&fm=26&gp=0.jpg",@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2094733030,1735566999&fm=26&gp=0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1589959916914&di=3ffaeeae77748ab978d62a75adb60b31&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fmobile%2F2018-11-16%2F5bee3b66f074e.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1589959916914&di=c4d40170977959a6c65a565e7101a506&imgtype=0&src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201408%2F29%2F20140829173229_zaeva.thumb.700_0.jpeg"];

    _carouselView = [TKCarouselView managerWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    _carouselView.backgroundColor = UIColor.redColor;
    _carouselView.currentSize = CGSizeMake(10, 4);
    _carouselView.otherSize = CGSizeMake(6, 4);
    [self.view addSubview:_carouselView];

    //这里要使用你喜欢的加载图片的框架
    [_carouselView reloadCarouselViewWithImageCount:array.count showImageBlock:^(UIButton *carouselButton, NSInteger index) {
       NSData *data = self.imageDict[[NSString stringWithFormat:@"%@",@(index)]];
        if (data == nil) {
           data = [NSData dataWithContentsOfURL:[NSURL URLWithString:array[index]]];
            if (data) {
                [self.imageDict setObject:data forKey:[NSString stringWithFormat:@"%@",@(index)]];
            }
        }

        [carouselButton setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    } imgClicked:^(NSInteger index) {

    }];
}

@end
