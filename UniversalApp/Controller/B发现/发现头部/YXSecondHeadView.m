//
//  YXSecondHeadView.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/7.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXSecondHeadView.h"
#import "YXSecondHeadCollectionViewCell.h"
#import "YXSecondHeadMoreCollectionViewCell.h"

@implementation YXSecondHeadView

- (void)drawRect:(CGRect)rect {
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    self.choujiangImg.userInteractionEnabled = YES;
    [self.choujiangImg addGestureRecognizer:click];
    
    [self.yxCollectionView registerNib:[UINib nibWithNibName:@"YXSecondHeadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YXSecondHeadCollectionViewCell"];
    
    [self.yxCollectionView registerNib:[UINib nibWithNibName:@"YXSecondHeadMoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YXSecondHeadMoreCollectionViewCell"];
    
    
    [self.yxCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HeaderView"];  //  一定要设置

    self.yxCollectionView.delegate = self;
    self.yxCollectionView.dataSource = self;
    self.yxCollectionView.backgroundColor = KClearColor;
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxCollectionView.contentSize = CGSizeMake(678, 82);
//    [self.yxCollectionView setCollectionViewLayout:self.flowLayout];

}
//- (UICollectionViewFlowLayout *)flowLayout{
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.footerReferenceSize = CGSizeMake(12, 56);  // 设置footerView大小
//    return flowLayout;
//}
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    UILabel * label  = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 12, 82)];
    label.numberOfLines = 0;
    [headerView addSubview:label];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"查 看 更 多"attributes: @{NSFontAttributeName: SYSTEMFONT(12),NSForegroundColorAttributeName:KWhiteColor}];
    label.attributedText = string;
    label.textColor = SEGMENT_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.userInteractionEnabled = YES;

    
    
    // 创建一个轻拍手势 同时绑定了一个事件
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    // 设置轻拍次数
    aTapGR.numberOfTapsRequired = 1;
    // 添加手势
    [label addGestureRecognizer:aTapGR];
    
    return headerView;
}
-(void)tapGRAction:(id)tap{
    self.moretagblock();

}
// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(34, 82);
}
-(void)setHeaderDate:(NSMutableArray *)dataArray{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:dataArray];
    [self.yxCollectionView reloadData];
}
-(void)clickAction:(id)tap{
    if (![userManager loadUserInfo]) {
         KPostNotification(KNotificationLoginStateChange, @NO);
         return;
    }
    self.choujiangblock();
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
        YXSecondHeadCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXSecondHeadCollectionViewCell" forIndexPath:indexPath];
        NSDictionary * dic = self.dataArray[indexPath.row];
        cell.tagTitle.text = [@"# " append:dic[@"tag"]];
        [cell.tagImageView sd_setImageWithURL:[NSURL URLWithString:[IMG_URI append:dic[@"photo"]]] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
        return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.clickCollectionItemBlock(self.dataArray[indexPath.row][@"tag"]);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(0, 0, 0,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        return CGSizeMake(110, 82);
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

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
//    CGFloat offset = scrollView.contentOffset.x;
//    CGFloat collWidth = self.yxCollectionView.frame.size.width;
//    UIColor * clolor222 = kRGBA(222, 222, 222, 1.0);
//    if (offset == 0) {
//        self.yuan1.backgroundColor = SEGMENT_COLOR;
//        self.yuan2.backgroundColor = self.yuan3.backgroundColor = clolor222;
//    }else if (offset == collWidth) {
//        self.yuan2.backgroundColor = SEGMENT_COLOR;
//        self.yuan1.backgroundColor = self.yuan3.backgroundColor = clolor222;
//    }else {
//        self.yuan3.backgroundColor = SEGMENT_COLOR;
//        self.yuan1.backgroundColor = self.yuan2.backgroundColor = clolor222;
//    }
}
- (IBAction)btn1Action:(UIButton *)sender {
    self.clickCollectionItemBlock(sender.titleLabel.text);
}
@end
