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

@end

NS_ASSUME_NONNULL_END
