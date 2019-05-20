//
//  YXHomeXueJiaPinPaiSearchViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeXueJiaPinPaiSearchViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (nonatomic,strong) NSString * searchText;

@end

NS_ASSUME_NONNULL_END
