//
//  YXJiFenShop1TableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/9.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickCollectionItemBlock)(NSDictionary *);
@interface YXJiFenShop1TableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *yxCollectionView;
-(void)setCellData:(NSDictionary *)dic;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UILabel *cell1Title;
@property (weak, nonatomic) IBOutlet UILabel *cell1Tag;
@property (nonatomic,copy) ClickCollectionItemBlock clickCollectionItemBlock;

@end

NS_ASSUME_NONNULL_END
