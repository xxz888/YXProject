//
//  YXSecondHeadView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/7.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickCollectionItemBlock)(NSString *);
typedef void(^MoreTagBlock)();

@interface YXSecondHeadView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *yxCollectionView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UIImageView *choujiangImg;
@property (nonatomic,copy) ClickCollectionItemBlock clickCollectionItemBlock;
-(void)setCellData:(NSMutableArray *)startDataArray;
@property (nonatomic,copy) MoreTagBlock moretagblock;
@property (weak, nonatomic) IBOutlet UIView *yuan1;
@property (weak, nonatomic) IBOutlet UIView *yuan2;
@property (weak, nonatomic) IBOutlet UIView *yuan3;

@end

NS_ASSUME_NONNULL_END
