//
//  ClassifyCollection.m
//  DiffLayoutCollection
//
//  Created by 张斌斌 on 2017/8/17.
//  Copyright © 2017年 张斌. All rights reserved.
//

#import "ClassifyCollection.h"

#import "BKDoubleCollectionViewCell.h"

#import "BKSingleCollectionViewCell.h"
#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenWidth ScreenBounds.size.width
#define ScreenHeight ScreenBounds.size.height
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
@implementation ClassifyCollection

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = RGB(242, 242, 242);
        self.dataSource = self;
        self.delegate = self;
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[BKDoubleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BKDoubleCollectionViewCell class])];
        [self registerClass:[BKSingleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BKSingleCollectionViewCell class])];
          }
    return self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.showType == singleLineShowOneGoods) {
        
        BKSingleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BKSingleCollectionViewCell class]) forIndexPath:indexPath];
        cell.goodsNameLabel.text = self.dataArray[indexPath.row][@"name"];
        if ([self.dataArray[indexPath.row][@"photo_list"] count] > 0) {
            NSString * str = [(NSMutableString *)self.dataArray[indexPath.row][@"photo_list"][0][@"photo"] replaceAll:@" " target:@"%20"];
            [cell.goodsImgeView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        }else{
            [cell.goodsImgeView setImage:[UIImage imageNamed:@"img_moren"]];
        }
        cell.goodsPriceLabel.text = kGetString(self.dataArray[indexPath.row][@"price"]);
        return cell;
    }else{
        
        BKDoubleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BKDoubleCollectionViewCell class]) forIndexPath:indexPath];
        cell.goodsNameLabel.text = self.dataArray[indexPath.row][@"name"];
        if ([self.dataArray[indexPath.row][@"photo_list"] count] > 0) {
            NSString * str = [(NSMutableString *)self.dataArray[indexPath.row][@"photo_list"][0][@"photo"] replaceAll:@" " target:@"%20"];
            [cell.goodsImgeView sd_setImageWithURL:[NSURL URLWithString: str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        }else{
            [cell.goodsImgeView setImage:[UIImage imageNamed:@"img_moren"]];
        }
        
        
        cell.goodsPriceLabel.text = kGetString(self.dataArray[indexPath.row][@"price"]);
        return cell;
        
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showType == singleLineShowOneGoods) {
        
        return CGSizeMake(ScreenWidth, 117);
    } else {
        CGFloat height = ScreenWidth * 228/375.0f;
        return CGSizeMake(ScreenWidth/2.0-0.5, height);
    }
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.001f;

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.001f;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.block(indexPath.row);
}

#pragma mark - set方法
-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self reloadData];
}

-(void)setShowType:(GoodsListShowType)showType
{
    _showType = showType;
    [self reloadData];
}

@end
