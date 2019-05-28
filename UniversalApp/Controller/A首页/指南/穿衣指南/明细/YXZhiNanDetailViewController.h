//
//  YXZhiNanDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXZhiNanDetailViewController : RootViewController
    @property (weak, nonatomic) IBOutlet UITableView *yxTableView;
    @property (nonatomic,strong) NSDictionary * startDic;

@end

NS_ASSUME_NONNULL_END
