//
//  YXJiFenShop2TableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/9.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXJiFenShop2TableViewCell.h"
#import "YXJiFenShop2CollectionViewCell.h"

@implementation YXJiFenShop2TableViewCell

-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
        
      }
      return  self;
}
-(void)clickAction:(id)sender{
    self.clickHeaderImgblock(NSIntegerToNSString(self.jifenImv.tag));
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //添加点击手势
              UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
              click.numberOfTapsRequired = 1;
    self.jifenImv.userInteractionEnabled = YES;
              [self.jifenImv addGestureRecognizer:click];
    self.yxCollectionView.alwaysBounceHorizontal = YES;
    self.yxCollectionView.showsHorizontalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.yxCollectionView.collectionViewLayout = layout;
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxCollectionView.delegate = self;
    self.yxCollectionView.dataSource = self;
    [self.yxCollectionView registerNib:[UINib nibWithNibName:@"YXJiFenShop2CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YXJiFenShop2CollectionViewCell"];
    
}

-(void)setCellData:(NSDictionary *)dic{
    self.jifenImv.tag = [dic[@"commodify_id"] integerValue];
    [self.jifenImv sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:dic[@"photo"]]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:dic[@"commodity_list"]];
    [self.yxCollectionView reloadData];
}

#pragma mark - Collection Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YXJiFenShop2CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXJiFenShop2CollectionViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.collTitle.text = dic[@"name"];
    cell.collJifen.text = kGetString(dic[@"integral"]);
    if ([dic[@"photo_list"] count] != 0) {
            [cell.collImv sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:dic[@"photo_list"][0][@"photo"]]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    }
   
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.clickCollectionItemBlock(self.dataArray[indexPath.row]);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat cellWidth = CGRectGetWidth(self.yxCollectionView.frame);
    CGFloat cellHeight = CGRectGetHeight(self.yxCollectionView.frame);

    return CGSizeMake(128 , cellHeight);
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
