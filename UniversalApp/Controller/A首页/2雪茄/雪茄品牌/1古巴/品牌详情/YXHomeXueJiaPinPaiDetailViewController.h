//
//  YXHomeXueJiaPinPaiDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/7.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeXueJiaPinPaiDetailViewController : UITableViewController

@property(nonatomic,strong)NSMutableDictionary * dicData;
@property(nonatomic,strong)NSMutableDictionary * dicStartData;

@property (weak, nonatomic) IBOutlet UIImageView *section1ImageView;
@property (weak, nonatomic) IBOutlet UILabel *section1TitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *section1countLbl;
@property (weak, nonatomic) IBOutlet UIButton *section1GuanZhuBtn;
- (IBAction)section1GuanZhuAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *section1TextView;

@property (nonatomic,assign) BOOL whereCome;//yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品


@end

NS_ASSUME_NONNULL_END
