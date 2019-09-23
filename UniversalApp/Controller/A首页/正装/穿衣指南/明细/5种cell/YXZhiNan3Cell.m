//
//  YXZhiNan3Cell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNan3Cell.h"
#import "SDPhotoBrowser.h"

@interface YXZhiNan3Cell()<SDPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray *picPathStringsArray;
@end
@implementation YXZhiNan3Cell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return  self;
}

-(void)setup{
    ViewRadius(self.photoImgView, 5);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setCellData:(NSDictionary *)dic{
    
    self.photoHeight.constant = [dic[@"ratio"] doubleValue] == 0 ? 180: (KScreenWidth - 30)* [dic[@"ratio"] doubleValue];
    NSString * str = [(NSMutableString *)dic[@"detail"] replaceAll:@" " target:@"%20"];
    [self.photoImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    
    self.picPathStringsArray = [[NSMutableArray alloc]init];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [self.photoImgView addGestureRecognizer:tap];
    [self.picPathStringsArray addObject:str];
    
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

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.picPathStringsArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
//    UIImageView *imageView = self.subviews[index];
    return self.photoImgView.image;
}


@end
