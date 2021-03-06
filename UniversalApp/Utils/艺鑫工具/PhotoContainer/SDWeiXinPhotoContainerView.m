//
//  SDWeiXinPhotoContainerView.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDWeiXinPhotoContainerView.h"

#import "UIView+SDAutoLayout.h"

#import "SDPhotoBrowser.h"

@interface SDWeiXinPhotoContainerView () <SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation SDWeiXinPhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = KWhiteColor;
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        ViewRadius(imageView, 5);
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}


- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = 0;
//    if (_picPathStringsArray.count == 1) {
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_picPathStringsArray[0]]];
//        UIImage *image = [UIImage imageWithData:data];
//        if (image.size.width) {
//            itemH = image.size.height / image.size.width * itemW;
//        }
//    } else {
        itemH = itemW;
//    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    //如果为两张图的话，间隔为10，其余为5
    CGFloat margin = Other_Image_space;
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.contentMode = 2;
        imageView.hidden = NO;
//        imageView.image = [UIImage imageNamed:obj];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
        if (_picPathStringsArray.count == 4) {
          //发现界面
             if (idx == 2) {
                 imageView.frame = CGRectMake(0 * (itemW + margin), 1 * (itemH + margin), itemW, itemH);
             }else if (idx == 3){
                 imageView.frame = CGRectMake(1 * (itemW + margin), 1 * (itemH + margin), itemW, itemH);
             }
        }
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.picPathStringsArray.count;
    browser.delegate = self;
    [browser show];
}
//单张图片的宽度
- (CGFloat)itemWidthForPicPathArray:(NSArray *)array{
    if (self.isMineCome) {
        if(self.picPathStringsArray.count == 1 || self.picPathStringsArray.count == 2 ){
            return  (self.width_sd - Other_Image_space)/2 ;
        }else if (self.picPathStringsArray.count == 3){
            return  (self.width_sd - Other_Image_space*2)/3 ;
        }else{
            return  (self.width_sd - Other_Image_space)/2 ;
        }
    }else{
        if(self.picPathStringsArray.count == 1 || self.picPathStringsArray.count == 2){
            return  (self.width_sd - Other_Image_space)/2 ;
        //3张图片以上的图片，为view的三分之一，减去两个间隔
        }else{
            return  (self.width_sd - Other_Image_space*2)/3 ;
        }
    }

}
//一行显示几张图片
- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array{
    return self.picPathStringsArray.count == 2 ? 2 : 3;
}


#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.picPathStringsArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}

@end
