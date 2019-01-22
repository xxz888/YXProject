//
//  YXHomeScoreActionViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeScoreActionViewController.h"
#import "QDCollectionViewDemoCell.h"
#import "YXHomeScoreActionCollectionViewCell.h"

#define A1 @[@"4",@"5",@"3",@"4",@"4",@"4",@"3",@"5",@"4",@"5",@"4",@"4",@"3",@"4",@"4",@"3",@"5",@"4"]

@interface YXHomeScoreActionViewController()
@property(nonatomic)UIButton * titleBtn;
@end
@implementation YXHomeScoreActionViewController

- (instancetype)initWithLayoutStyle:(QMUICollectionViewPagingLayoutStyle)style {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _collectionViewLayout = [[QMUICollectionViewPagingLayout alloc] initWithStyle:style];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithLayoutStyle:QMUICollectionViewPagingLayoutStyleDefault];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"开始记分";
    self.titleView.userInteractionEnabled = YES;
    [self.titleView addTarget:self action:@selector(handleTitleViewTouchEvent) forControlEvents:UIControlEventTouchUpInside];

}
-(void)viewDidLoad{
    [super viewDidLoad];
    _titleBtn = [UIButton buttonWithType:0];
    [_titleBtn setTitle:[self.ABArray[0] append:@"1洞"] forState:UIControlStateNormal];
    [_titleBtn setTitleColor:KBlackColor forState:UIControlStateNormal];
    _titleBtn.frame = CGRectMake(0, 0, KScreenWidth, 35);
    _titleBtn.layer.cornerRadius = 10;
    _titleBtn.layer.masksToBounds = YES;
    [_titleBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = _titleBtn;
}
- (void)initSubviews {
    [super initSubviews];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewLayout];
    self.collectionView.backgroundColor = UIColorClear;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"YXHomeScoreActionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YXHomeScoreActionCollectionViewCell"];
    [self.collectionView registerClass:[QDCollectionViewDemoCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    self.collectionView.pagingEnabled=YES;
    self.collectionViewLayout.sectionInset = [self sectionInset];
    


}
-(void)btnAction:(UIButton *)btn{
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    if (!CGSizeEqualToSize(self.collectionView.bounds.size, self.view.bounds.size)) {
//        self.collectionView.frame = self.view.bounds;
//        self.collectionViewLayout.sectionInset = [self sectionInset];
//        [self.collectionViewLayout invalidateLayout];
//    }
}

- (void)handleTitleViewTouchEvent {
    [self.collectionView qmui_scrollToTopAnimated:YES];
}

- (void)handleDirectionItemEvent {
//    self.collectionViewLayout.scrollDirection = self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionVertical ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
//    [self.collectionViewLayout invalidateLayout];
//    [self.collectionView qmui_scrollToTopAnimated:YES];
//    [self.collectionView reloadData];
//
//    [self setupNavigationItems];
//    [self.view setNeedsLayout];
}


- (UIEdgeInsets)sectionInset {
    return UIEdgeInsetsMake(64, 10, 0, 0);
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 18;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXHomeScoreActionCollectionViewCell *cell = (YXHomeScoreActionCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"YXHomeScoreActionCollectionViewCell" forIndexPath:indexPath];
//    cell.scrollDirection = self.collectionViewLayout.scrollDirection;
//    [cell setNeedsLayout];
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size = CGSizeMake(CGRectGetWidth(collectionView.bounds) - UIEdgeInsetsGetHorizontalValue(self.collectionViewLayout.sectionInset) - UIEdgeInsetsGetHorizontalValue(self.collectionView.qmui_contentInset), CGRectGetHeight(collectionView.bounds) - UIEdgeInsetsGetVerticalValue(self.collectionViewLayout.sectionInset) - UIEdgeInsetsGetVerticalValue(self.collectionView.qmui_contentInset));
    return size;
}
#pragma mark ========== 滑动结束后 ==========
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewEndScroll:scrollView];
}
- (void)scrollViewEndScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"%d",page);
    YXHomeScoreActionCollectionViewCell * cell = (YXHomeScoreActionCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0]];
    cell.biaozhunGanLbl.text = A1[page];
    
    NSString * tag = page+1<10 ? self.ABArray[0] : self.ABArray[1];
    NSInteger dong = page+1<10 ? page : page-9;
    NSString * title = [NSString stringWithFormat:@"%@%ld洞",tag,dong+1];
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
}


@end
