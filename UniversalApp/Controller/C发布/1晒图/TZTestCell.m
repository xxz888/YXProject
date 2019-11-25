//
//  TZTestCell.m
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZTestCell.h"
#import "UIView+Layout.h"
#import <Photos/Photos.h>

@implementation TZTestCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
        
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.backgroundColor = kRGBA(153, 153, 153, 0.8);
        [_deleteBtn setImage:[UIImage imageNamed:@"deleteButton"] forState:UIControlStateNormal];
        _deleteBtn.frame = CGRectMake(100-16, 0, 16, 16);
        [self addSubview:_deleteBtn];
        
        _videoImageView = [[UIImageView alloc]init];
        [_videoImageView setImage:[UIImage imageNamed:@"icon_video_play"]];
        [self addSubview:_videoImageView];
 
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0,0, self.tz_width, self.tz_height);
    _gifLable.frame = CGRectMake(self.tz_width - 25, self.tz_height - 14, 25, 14);
    _deleteBtn.frame = CGRectMake(self.tz_width - 15, 0, 15, 15);
    _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(4,4,4,4);
    ViewRadius(_imageView, 5);
    CGFloat width = self.tz_width / 4.0;
    _videoImageView.frame = CGRectMake(width, width, width, width);
    _videoImageView.center = self.center;
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    _videoImageView.hidden = asset.mediaType != PHAssetMediaTypeVideo;
    _gifLable.hidden = ![[asset valueForKey:@"filename"] containsString:@"GIF"];
}

- (void)setRow:(NSInteger)row {
    _row = row;
    _deleteBtn.tag = row;
}

- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc]init];
    
    UIView *cellSnapshotView = nil;
    
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}

@end
