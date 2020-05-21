# TKCarouselView
a carousel View tools.

Demo Project
==============

![demo](https://github.com/libtinker/TKCarouselView/blob/master/TKCarouselView/demo4.png)

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
    
    TKCarouselView *carouselView = [TKCarouselView initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width/2)];
    [self.view addSubview:carouselView];
    
    [carouselView reloadImageCount:imageNames.count itemAtIndexBlock:^(UIImageView *imageView, NSInteger index) {
        imageView.image = [UIImage imageNamed:imageNames[index]];
    } imageClickedBlock:^(NSInteger index) {
        NSLog(@"%@",@(index));
    }];
```

## License

TKCarouselView is released under the MIT license. See [LICENSE](https://github.com/libtinker/TKCarouselView/blob/master/LICENSE) for details.
