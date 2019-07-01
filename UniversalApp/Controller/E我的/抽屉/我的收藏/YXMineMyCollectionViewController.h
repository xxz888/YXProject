//
//  YXMineMyCollectionViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPinPaiDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXMineMyCollectionViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
- (IBAction)btnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel * noDataImg;

@end

NS_ASSUME_NONNULL_END
