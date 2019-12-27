//
//  YXZhiNanTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/17.
//  Copyright © 2019 徐阳. All rights reserved.
//
//17764509913
#import "YXZhiNanTableViewCell.h"
#import "YXZhiNanCollectionViewCell.h"
@interface YXZhiNanTableViewCell()
@end
@implementation YXZhiNanTableViewCell
+(CGFloat)jisuanHeight{
    return 0;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self baseCellConfig];
}
- (void)baseCellConfig{
    self.yxCollectionView.delegate = self;
    self.yxCollectionView.dataSource = self;
    self.yxCollectionView.showsHorizontalScrollIndicator = NO;
    [self.yxCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YXZhiNanCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"YXZhiNanCollectionViewCell"];
    self.yxCollectionView.tag = self.tag;
}
-(void)setCellData:(NSDictionary *)dic :(NSInteger)index{
    self.collArray = [NSMutableArray arrayWithArray:dic[@"child_list"]];
    self.titleLbl.text = [NSString stringWithFormat:@"0%ld/%@",index+1,dic[@"name"]];
    NSInteger n = [self.collArray count];
    self.collHeight.constant = 45 * (n/2+n%2);
    [self.yxCollectionView reloadData];
}
#pragma mark - Collection Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YXZhiNanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXZhiNanCollectionViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.collArray[indexPath.row];
    cell.titleLbl.text = dic[@"name"];
    cell.lockImv.hidden = YES;
    NSInteger is_lock = [dic[@"is_lock"] integerValue];
    NSInteger user_lock = [dic[@"user_lock"] integerValue];
    if (is_lock == 1 && user_lock == 0) {
        cell.titleLbl.backgroundColor = kRGBA(204, 204, 204, 1);
        cell.titleLbl.textColor = KWhiteColor;
    }else{
        cell.titleLbl.backgroundColor =  kRGBA(248, 248, 248, 1);
        cell.titleLbl.textColor = COLOR_333333;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.clickCollectionItemBlock(indexPath.row,self.tag);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat cellWidth = CGRectGetWidth(self.yxCollectionView.frame);
    return CGSizeMake((cellWidth-11)/2 , 44);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeZero;
}



@end
