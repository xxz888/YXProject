//
//  YXHomeXueJiaPinPaiLastDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeXueJiaPinPaiLastDetailViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property(nonatomic,strong)NSMutableDictionary * startDic;
@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,assign) BOOL whereCome;//NO代表正常 YES代表消息界面
@property (nonatomic,assign) BOOL PeiJianOrPinPai;//NO代表品牌 YES代表配件

@end

NS_ASSUME_NONNULL_END
