//
//  YXMineJiFenTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/8/30.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXMineJiFenTableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UIImageView *accImv;
@property (weak, nonatomic) IBOutlet UIButton *qiandaoBtn;
- (IBAction)qiandaoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *qiandaoView;
@property (weak, nonatomic) IBOutlet UILabel *lianxuqiandaoLbl;

@property (weak, nonatomic) IBOutlet UIButton *finish1;
@property (weak, nonatomic) IBOutlet UIButton *finish2;
@property (weak, nonatomic) IBOutlet UIButton *finish3;
@property (weak, nonatomic) IBOutlet UIButton *finish4;
@property (weak, nonatomic) IBOutlet UIButton *finish5;
@property (weak, nonatomic) IBOutlet UIButton *finish6;
@property (weak, nonatomic) IBOutlet UIButton *finish7;
@property (weak, nonatomic) IBOutlet UIButton *finish8;
@property (weak, nonatomic) IBOutlet UIButton *finish9;
- (IBAction)jifenHistoryAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *day3;
@property (weak, nonatomic) IBOutlet UILabel *day4;
@property (weak, nonatomic) IBOutlet UILabel *day5;
@property (weak, nonatomic) IBOutlet UILabel *day6;
@property (weak, nonatomic) IBOutlet UILabel *day7;
@property (weak, nonatomic) IBOutlet UILabel *jifenNumLbl;

@end

NS_ASSUME_NONNULL_END
