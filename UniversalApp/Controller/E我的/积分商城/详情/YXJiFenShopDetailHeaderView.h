//
//  YXJiFenShopDetailHeaderView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/9.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXJiFenShopDetailHeaderView : UIView <SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *lunboView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *jifen;
@property (weak, nonatomic) IBOutlet UILabel *cankaojia;
@property (weak, nonatomic) IBOutlet UILabel *shengyufenshu;
@property (nonatomic,strong) NSMutableArray * photoArray;
-(void)setHeaderView:(NSDictionary *)dic;
@property(nonatomic)SDCycleScrollView *cycleScrollView3;

@end

NS_ASSUME_NONNULL_END
