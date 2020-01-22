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
typedef void(^ChouJiangBlock)();

@interface YXSecondHeadView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UIImageView *choujiangImg;
@property (nonatomic,copy) ClickCollectionItemBlock clickCollectionItemBlock;
@property (nonatomic,copy) MoreTagBlock moretagblock;
@property (nonatomic,copy) ChouJiangBlock choujiangblock;


@property (weak, nonatomic) IBOutlet UICollectionView *yxCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UILabel *dongtaicount1;
- (IBAction)btn1Action:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dongtaicount2;
@property (weak, nonatomic) IBOutlet UILabel *dongtaicount3;
-(void)setHeaderDate:(NSMutableArray *)dataArray;
@end

NS_ASSUME_NONNULL_END
