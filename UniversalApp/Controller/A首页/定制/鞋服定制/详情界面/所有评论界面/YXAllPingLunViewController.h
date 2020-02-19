//
//  YXAllPingLunViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXAllPingLunViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
- (IBAction)btnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (strong, nonatomic) NSDictionary * startDic;

@end

NS_ASSUME_NONNULL_END
