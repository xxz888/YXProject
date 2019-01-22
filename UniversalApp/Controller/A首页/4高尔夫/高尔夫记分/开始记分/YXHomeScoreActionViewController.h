//
//  YXHomeScoreActionViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeScoreActionViewController : QMUICommonViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong, readonly) UICollectionView *collectionView;
@property(nonatomic, strong, readonly) QMUICollectionViewPagingLayout *collectionViewLayout;

- (instancetype)initWithLayoutStyle:(QMUICollectionViewPagingLayoutStyle)style;

@property (nonatomic,strong) NSMutableArray * ABArray;

@end

NS_ASSUME_NONNULL_END
