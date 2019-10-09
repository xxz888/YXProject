//
//  YXJiFenShopViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/9.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXJiFenShopViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (nonatomic,strong) NSMutableArray * lunboArray;

@end

NS_ASSUME_NONNULL_END
