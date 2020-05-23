//
//  ViewController.m
//  TKCarouselView
//
//  Created by 天空吸引我 on 2020/5/20.
//  Copyright © 2020 libtinker. All rights reserved.
//

#import "ViewController.h"
#import "TKCarouselView.h"
#import <CommonCrypto/CommonDigest.h>

#define WeakSelf __weak typeof(self) weakSelf = self;

@interface ViewController ()
@property (nonatomic,strong)  TKCarouselView *carouselView;
@property (nonatomic,strong) NSMutableDictionary *imageDict;
@property (nonatomic,strong) dispatch_queue_t queue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.queue = dispatch_queue_create("libtinker.TKCarouselView", DISPATCH_QUEUE_CONCURRENT);
    _imageDict = [NSMutableDictionary dictionary];

    [self testTKCarouselView];
}
- (void)testTKCarouselView {
    NSArray *array = @[@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3658587479,3162190896&fm=26&gp=0.jpg",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1322896087,2736086242&fm=26&gp=0.jpg",@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2716219330,3814054151&fm=26&gp=0.jpg",@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2776433555,1185570728&fm=26&gp=0.jpg"];

    _carouselView = [[TKCarouselView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width/2)];
    _carouselView.pageControl.currentDotSize = CGSizeMake(10, 4);
    _carouselView.pageControl.otherDotSize = CGSizeMake(8, 4);
    _carouselView.pageControl.currentDotRadius = 2.0;
    _carouselView.pageControl.otherDotRadius = 2.0;
    _carouselView.placeholderImageView.image = [UIImage imageNamed:@"placeholderImage.jpg"];
    [self.view addSubview:_carouselView];

    NSLog(@"---------------------");
    //    array = @[];//用于测试placeholderImageView
    WeakSelf
    [_carouselView reloadImageCount:array.count itemAtIndexBlock:^(UIImageView *imageView, NSInteger index) {
        //推荐使用sd等网络框架
        [weakSelf downloadDataWithURLString:array[index] complete:^(NSData *data, UIImage *image, NSError *error) {
            if (image) {
                imageView.image = image;
            }else {
                imageView.image = [UIImage imageNamed:@"placeholderImage.jpg"];
            }
        }];

    } imageClickedBlock:^(NSInteger index) {
        NSLog(@"%@",@(index));
    }];

}

- (void)downloadDataWithURLString:(NSString *)URLString complete:(void(^)(NSData *data,UIImage *image,NSError *error))complete {
    NSString *fileName = [self tk_md5String:URLString];
    NSString *filePath = [self filePathWithFileName:fileName ext:URLString.pathExtension];
    [self readMemoryWithFileName:fileName complete:^(NSData *data, NSError *error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (complete) complete(data,image,error);
        } else {
            if (complete) complete (nil,nil,nil);//回调展示占位图
            [self readDismemoryWithFileName:filePath complete:^(NSData *data, NSError *error) {
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (complete) complete(data,image,error);
                }else {
                    [self downloadDataWithURLName:URLString complete:^(NSData *data, NSError *error) {
                        if (data) {
                            self.imageDict[fileName] = data;
                            [data writeToFile:filePath atomically:YES];
                            UIImage *image = [UIImage imageWithData:data];
                            if (complete) complete(data,image,error);
                        }else {
                            if (complete) complete(nil,nil,error);
                        }
                    }];
                }
            }];
        }
    }];
}

//内存操作
- (void)readMemoryWithFileName:(NSString *)fileName complete:(void(^)(NSData *data,NSError *error))complete{
    NSData *data = self.imageDict[fileName];
    if (data) {
        if (complete) complete(data,nil);
    }else {
        NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4000 userInfo:@{NSLocalizedFailureReasonErrorKey:@"内存中没有该数据"}];
        if (complete) complete(nil,error);
    }
}

//磁盘操作
- (void)readDismemoryWithFileName:(NSString *)fileName complete:(void(^)(NSData *data,NSError *error))complete {
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
       NSData *data = [NSData dataWithContentsOfFile:fileName];
        if (data) {
            if (complete) complete(data,nil);
        }else {
            NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4001 userInfo:@{NSLocalizedFailureReasonErrorKey:@"文件已损坏"}];
                   if (complete) complete(nil,error);
        }
    }else {
        NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4002 userInfo:@{NSLocalizedFailureReasonErrorKey:@"磁盘中没有该数据"}];
        if (complete) complete(nil,error);
    }
}


- (void)downloadDataWithURLName:(NSString *)URLName complete:(void(^)(NSData *data,NSError *error))complete {
    dispatch_async(self.queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLName]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                if(complete) complete(data,nil);
            }else {
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4002 userInfo:@{NSLocalizedFailureReasonErrorKey:@"下载失败"}];
                if (complete) complete(nil,error);
            }
        });
    });
}

- (NSString *)filePathWithFileName:(NSString *)fileName ext:(NSString *)ext{
    return [[[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:ext];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (NSString *)tk_md5String:(NSString *)string {
    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
#pragma clang diagnostic pop

@end
