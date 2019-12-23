//
//  YXChildPingLunViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/23.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXChildPingLunViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
- (IBAction)backVcAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

NS_ASSUME_NONNULL_END
