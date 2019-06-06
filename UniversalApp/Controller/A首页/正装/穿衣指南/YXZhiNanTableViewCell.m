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
    // Initialization code
    [self baseCellConfig];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// Config
- (void)baseCellConfig{
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxCollectionView.delegate = self;
    self.yxCollectionView.dataSource = self;
    self.yxCollectionView.showsHorizontalScrollIndicator = NO;
    [self.yxCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YXZhiNanCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"YXZhiNanCollectionViewCell"];
}


-(void)requestZhiNanGet:(NSString *)wpId{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"1/%@",wpId];
    [YXPLUS_MANAGER requestZhiNan1Get:par success:^(id object) {
      
        [weakself.yxCollectionView reloadData];

  
    }];
}
-(void)setCellData:(NSDictionary *)dic tagIndex:(NSInteger)index cellArray:(NSArray *)cellArray{
    self.dataArray = [NSMutableArray arrayWithArray:cellArray];
    self.titleLbl.text = [NSString stringWithFormat:@"0%ld/%@",index+1,dic[@"name"]];
    CGFloat h = 60;
    
    if (self.dataArray.count == 3) {
        h =  h * 2;
    }
    self.collHeight.constant = h;

    [self.yxCollectionView reloadData];

//    [self requestZhiNanGet:dic[@"id"]];
}
#pragma mark - Collection Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YXZhiNanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXZhiNanCollectionViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.titleLbl.text = dic[@"name"];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.clickCollectionItemBlock(self.dataArray[indexPath.row]);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellHeight = CGRectGetHeight(self.yxCollectionView.frame);
    CGFloat cellWidth = CGRectGetWidth(self.yxCollectionView.frame);
    

    return CGSizeMake((cellWidth)/2 , 60);
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
