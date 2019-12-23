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
@property (weak, nonatomic) IBOutlet UIImageView *collImv;
- (IBAction)collAction:(id)sender;
- (IBAction)shareAction:(id)sender;
- (IBAction)moreAction:(id)sender;
- (IBAction)telAction:(id)sender;


@end

NS_ASSUME_NONNULL_END
