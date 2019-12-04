//
//  YXSecondHeadView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/7.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXSecondHeadView.h"
#import "YXSecondHeadCollectionViewCell.h"

@implementation YXSecondHeadView

- (void)drawRect:(CGRect)rect {
    [self baseCellConfig];
}
// Config
- (void)baseCellConfig{
    
    self.yxCollectionView.delegate = self;
    self.yxCollectionView.dataSource = self;
    self.yxCollectionView.showsHorizontalScrollIndicator = NO;
    self.yxCollectionView.alwaysBounceHorizontal = NO;
    self.yxCollectionView.pagingEnabled = YES;

    [self.yxCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YXSecondHeadCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"YXSecondHeadCollectionViewCell"];
    

}
/*
 今日LOOK

 一周穿搭

 普通人穿搭自救指南

 穿西服的男人

 职场穿搭

 抽雪茄的女人

 Cigar入坑必看

 灰茄达人俱乐部

 晒出你的好收藏

 酒柜必备好酒

 什么值得买

 瞧瞧我的鞋柜
 */
-(void)setCellData:(NSMutableArray *)startDataArray{
    self.dataArray = [[NSMutableArray alloc]init];
    [self.dataArray addObjectsFromArray:@[
  @{@"type":@"#今日LOOK"},
  @{@"type":@"#一周穿搭"},
  @{@"type":@"#普通人穿搭自救指南"},
  @{@"type":@"#穿西服的男人"},
  @{@"type":@"#职场穿搭"},
  
  @{@"type":@"#抽雪茄的女人"},
  @{@"type":@"#Cigar入坑必看"},
  @{@"type":@"#灰茄达人俱乐部"},
  @{@"type":@"#酒柜必备好酒"},
  @{@"type":@"#什么值得买"},
  
  @{@"type":@"#瞧瞧我的鞋柜"},
  ]];
    [self.yxCollectionView reloadData];
}
- (IBAction)moreAction:(id)sender {
    self.moretagblock();
}
#pragma mark - Collection Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YXSecondHeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXSecondHeadCollectionViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.tagTitle.text = dic[@"type"];
    cell.tagImageView.image = IMAGE_NAMED([dic[@"type"] split:@"#"][1]);
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.clickCollectionItemBlock(self.dataArray[indexPath.row][@"type"]);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.yxCollectionView.frame.size.width-10)/2 , 50);
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
#pragma mark - UIScrollDelegate
 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging &&    !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
       // 停止类型3
       BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
       if (dragToDragStop) {
          [self scrollViewDidEndScroll:scrollView];
       }
  }
}
#pragma mark - scrollView 停止滚动监测
- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat collWidth = self.yxCollectionView.frame.size.width;
    UIColor * clolor222 = kRGBA(222, 222, 222, 1.0);
    if (offset == 0) {
        self.yuan1.backgroundColor = SEGMENT_COLOR;
        self.yuan2.backgroundColor = self.yuan3.backgroundColor = clolor222;
    }else if (offset == collWidth) {
        self.yuan2.backgroundColor = SEGMENT_COLOR;
        self.yuan1.backgroundColor = self.yuan3.backgroundColor = clolor222;
    }else {
        self.yuan3.backgroundColor = SEGMENT_COLOR;
        self.yuan1.backgroundColor = self.yuan2.backgroundColor = clolor222;
    }
}
@end
