# TKCarouselView
TKCarouselView is a roving graph tool that supports app styles such as jd and Tmall.

Demo Project
==============

![demo](https://github.com/libtinker/TKCarouselView/blob/master/TKCarouselView/demo.png)

Installation
==============
### CocoaPods
1. Add `pod 'TKCarouselView'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<TKCarouselView.h\>.

Usage
==============

``` objective-c
    NSArray *imageNames = @[@"image_name_1.png",@"image_name_2.png",@"image_name_3.png",@"image_name_4.png"];
    
    TKCarouselView *carouselView = [[TKCarouselView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width/2)];
    [self.view addSubview:carouselView];
    
    [carouselView reloadImageCount:imageNames.count itemAtIndexBlock:^(UIImageView *imageView, NSInteger index) {
        imageView.image = [UIImage imageNamed:imageNames[index]];
    } imageClickedBlock:^(NSInteger index) {
        NSLog(@"%@",@(index));
    }];
```

## License

TKCarouselView is released under the MIT license. See [LICENSE](https://github.com/libtinker/TKCarouselView/blob/master/LICENSE) for details.

# 中文介绍

# TKCarouselView
TKCarouselView 是一款轮播图工具，支持京东、天猫等app样式.

项目演示
==============

![demo](https://github.com/libtinker/TKCarouselView/blob/master/TKCarouselView/demo.png)

安装
==============
### CocoaPods
1. 添加 `pod 'TKCarouselView'` 到你的 Podfile.
2. 跑 `pod install` 或者 `pod update`.
3. 包含头文件 Import \<TKCarouselView.h\>.

使用代码
==============

``` objective-c
    NSArray *imageNames = @[@"image_name_1.png",@"image_name_2.png",@"image_name_3.png",@"image_name_4.png"];
    
    TKCarouselView *carouselView = [[TKCarouselView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width/2)];
    [self.view addSubview:carouselView];
    
    [carouselView reloadImageCount:imageNames.count itemAtIndexBlock:^(UIImageView *imageView, NSInteger index) {
        imageView.image = [UIImage imageNamed:imageNames[index]];
    } imageClickedBlock:^(NSInteger index) {
        NSLog(@"%@",@(index));
    }];
```
## 许可证

TKCarouselView is released under the MIT license. See [LICENSE](https://github.com/libtinker/TKCarouselView/blob/master/LICENSE) for details.

