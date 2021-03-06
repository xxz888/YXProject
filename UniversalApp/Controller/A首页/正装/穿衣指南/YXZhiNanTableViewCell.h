//
//  YXZhiNanTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/17.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^RefreshCellBlock)(NSArray *);

typedef void(^ClickCollectionItemBlock)(NSInteger,NSInteger);
@interface YXZhiNanTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *yxCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (nonatomic,strong) NSDictionary * collViewDic;
@property (nonatomic,strong) NSString * wpId;
@property (nonatomic,strong) NSMutableArray * collArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collHeight;
-(void)setCellData:(NSDictionary *)dic :(NSInteger)index;
@property (nonatomic,copy) ClickCollectionItemBlock clickCollectionItemBlock;
@property (nonatomic,copy) RefreshCellBlock refreshCellBlock;
@end

NS_ASSUME_NONNULL_END
