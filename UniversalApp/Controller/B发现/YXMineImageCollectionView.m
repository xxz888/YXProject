//
//  YXMineImageCollectionView.m
//  DiffLayoutCollection
//
//  Created by 张斌斌 on 2017/8/17.
//  Copyright © 2017年 张斌. All rights reserved.
//

#import "YXMineImageCollectionView.h"

#import "YXMineImageCollectionViewCell.h"

#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenWidth ScreenBounds.size.width
#define ScreenHeight ScreenBounds.size.height
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
@implementation YXMineImageCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = KWhiteColor;
        self.dataSource = self;
        self.delegate = self;
        self.alwaysBounceVertical = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self registerNib:[UINib nibWithNibName:@"YXMineImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YXMineImageCollectionViewCell"];
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
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
//    if (self.showType == singleLineShowOneGoods) {
        YXMineImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXMineImageCollectionViewCell" forIndexPath:indexPath];
        //cell.singleGoodsModel = self.dataArray[indexPath.row];
        
        cell.topViewConstraint.constant =  self.whereCome ? 0 : 60;
        cell.topView.hidden = self.whereCome;
        cell.essayTitleImageView.tag = indexPath.row;
    
    
        [cell.essayTitleImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        cell.essayNameLbl.text = dic[@"user_name"];
        cell.essayTimeLbl.text = [ShareManager timestampSwitchTime:[dic[@"publish_time"] integerValue] andFormatter:@""];
    
        [cell.midImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo1"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        
        BOOL isp =  [dic[@"is_praise"] integerValue] == 1;
        UIImage * likeImage = isp ? ZAN_IMG : UNZAN_IMG;
        [cell.likeBtn setBackgroundImage:likeImage forState:UIControlStateNormal];

        
        return cell;
//    }else{
//
//        YXMineImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YXMineImageCollectionViewCell class]) forIndexPath:indexPath];
//        //cell.doubleGoodsModel = self.dataArray[indexPath.row];
//        return cell;
//
//    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.indexPathBlock(indexPath);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.whereCome ? 300 - 60 : 30;
    if (self.showType == singleLineShowOneGoods) {
        return CGSizeMake(ScreenWidth, height);
    } else {
        return CGSizeMake((ScreenWidth-10)/2.0-0.5, height);
    }
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.001f;

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.001f;
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
