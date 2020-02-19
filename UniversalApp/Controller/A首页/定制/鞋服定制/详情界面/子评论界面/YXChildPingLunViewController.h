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
@property (weak, nonatomic) IBOutlet UIImageView *bottomMySelfImv;
- (IBAction)zanAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property(nonatomic,strong)NSDictionary * startDic;
@end

NS_ASSUME_NONNULL_END
