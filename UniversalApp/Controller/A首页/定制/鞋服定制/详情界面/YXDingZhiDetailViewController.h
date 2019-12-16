//
//  YXDingZhiDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/13.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXDingZhiDetailViewController : RootViewController
- (IBAction)backVcAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;

@end

NS_ASSUME_NONNULL_END
