//
//  YXJiFenShop1TableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/9.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXJiFenShop1TableViewCell.h"
#import "YXJiFenShop1CollectionViewCell.h"

@implementation YXJiFenShop1TableViewCell
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {

    }
    return  self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.yxCollectionView.alwaysBounceHorizontal = YES;
    self.yxCollectionView.showsHorizontalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.yxCollectionView.collectionViewLayout = layout;
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxCollectionView.delegate = self;
    self.yxCollectionView.dataSource = self;
    [self.yxCollectionView registerNib:[UINib nibWithNibName:@"YXJiFenShop1CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YXJiFenShop1CollectionViewCell"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




-(void)setCellData:(NSDictionary *)dic{
    self.cell1Title.text = dic[@"name"];
    self.cell1Tag.text = dic[@"label"];
    self.yxCollectionView.tag = self.tag;
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
    YXJiFenShop1CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXJiFenShop1CollectionViewCell" forIndexPath:indexPath];
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
    
    return UIEdgeInsetsMake(0, 15, 0,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat cellWidth = CGRectGetWidth(self.yxCollectionView.frame);
    CGFloat cellHeight = CGRectGetHeight(self.yxCollectionView.frame)/2;

    return CGSizeMake((cellWidth-45)/2 , 225);
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
