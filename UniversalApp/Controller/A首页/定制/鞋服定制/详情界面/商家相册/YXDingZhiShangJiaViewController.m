//
//  YXDingZhiShangJiaViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2020/2/7.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import "YXDingZhiShangJiaViewController.h"
#import "YXDIngZhiShangJiaCollectionViewCell.h"
#import "UIImage+ImgSize.h"
#import "SDWeiXinPhotoContainerView.h"
#import "SDPhotoBrowser.h"

@interface YXDingZhiShangJiaViewController ()<SDPhotoBrowserDelegate>{
    BOOL _selectSegmentBool;//no相册 yes视频
}
@property(nonatomic,strong)NSMutableArray * imgArray;
@property(nonatomic,strong)NSMutableArray * videoArray;
@property (nonatomic, strong) NSMutableArray *picPathStringsArray;

@property (strong, nonatomic) SDWeiXinPhotoContainerView *picContainerView;
@end

@implementation YXDingZhiShangJiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectSegmentBool = NO;
    
    [self changeSelectStatus:self.btn1 bottomView:self.bottom1];
    [self changeUnSelectStatus:self.btn2 bottomView:self.bottom2];
    self.imgArray = [[NSMutableArray alloc]init];
    self.videoArray = [[NSMutableArray alloc]init];
    self.picPathStringsArray = [[NSMutableArray alloc]init];

    for (NSString * str in self.startArray) {
        if ([str contains:@"png"]) {
            [self.imgArray addObject:str];
        }else{
            [self.videoArray addObject:str];
        }
    }
    [self.yxCollectionView registerNib:[UINib nibWithNibName:@"YXDIngZhiShangJiaCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YXDIngZhiShangJiaCollectionViewCell"];
}


#pragma mark - Collection Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _selectSegmentBool ? self.videoArray.count : self.imgArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        YXDIngZhiShangJiaCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXDIngZhiShangJiaCollectionViewCell" forIndexPath:indexPath];
        cell.shangjiaPlayBtn.hidden = !_selectSegmentBool;
    if (_selectSegmentBool) {
        
    }else{
        NSString * imgString = self.imgArray[indexPath.row];
        [cell.shangjiaImv sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:imgString]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    }
      
        return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        YXDIngZhiShangJiaCollectionViewCell * cell = [self.yxCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [self.picPathStringsArray removeAllObjects];
     for (NSString * url in self.startArray) {
        [self.picPathStringsArray addObject:[IMG_URI append:url]];
     }
    
         SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
     browser.currentImageIndex = indexPath.row;
     browser.sourceImagesContainerView = cell;
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

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    YXDIngZhiShangJiaCollectionViewCell * cell = [self.yxCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cell.shangjiaImv.image;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 11;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(0, 0, 0,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        CGFloat signWidth = (KScreenWidth-32-11)/2;
        return CGSizeMake(signWidth, signWidth * 0.75);
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeZero;
}


- (IBAction)backVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnAction:(UIButton *)btn {
    switch (btn.tag) {
        case 1001:{
            _selectSegmentBool = NO;
            [self changeUnSelectStatus:self.btn2 bottomView:self.bottom2];
            [self changeSelectStatus:self.btn1 bottomView:self.bottom1];
            [self.yxCollectionView reloadData];
        }
            break;
        case 1002:{
            _selectSegmentBool = YES;
            [self changeSelectStatus:self.btn2 bottomView:self.bottom2];
            [self changeUnSelectStatus:self.btn1 bottomView:self.bottom1];
            [self.yxCollectionView reloadData];
        }
            break;
        default:
            break;
    }
}
-(void)changeUnSelectStatus:(UIButton *)btn bottomView:(UIView *)bottomView{
    [btn setTitleColor:COLOR_999999 forState:0];
    bottomView.hidden = YES;
}
-(void)changeSelectStatus:(UIButton *)btn bottomView:(UIView *)bottomView{
    [btn setTitleColor:SEGMENT_COLOR forState:0];
    bottomView.hidden = NO;
}
@end
