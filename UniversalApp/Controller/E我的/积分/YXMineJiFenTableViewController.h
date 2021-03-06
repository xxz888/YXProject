//
//  YXMineJiFenTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/8/30.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^backVcBlock)(void);

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

@property (weak, nonatomic) IBOutlet UILabel *jifenNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property(nonatomic, copy) backVcBlock  backvcBlock;//用户信息



@property (weak, nonatomic) IBOutlet UILabel *day0;
@property (weak, nonatomic) IBOutlet UILabel *day1;
@property (weak, nonatomic) IBOutlet UILabel *day2;
@property (weak, nonatomic) IBOutlet UILabel *day3;
@property (weak, nonatomic) IBOutlet UILabel *day4;
@property (weak, nonatomic) IBOutlet UILabel *day5;
@property (weak, nonatomic) IBOutlet UILabel *day6;




@property (weak, nonatomic) IBOutlet UIImageView *img0;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *img5;
@property (weak, nonatomic) IBOutlet UIImageView *img6;


@property (weak, nonatomic) IBOutlet UILabel *colorDay0;
@property (weak, nonatomic) IBOutlet UILabel *colorDay1;
@property (weak, nonatomic) IBOutlet UILabel *colorDay2;
@property (weak, nonatomic) IBOutlet UILabel *colorDay3;
@property (weak, nonatomic) IBOutlet UILabel *colorDay4;
@property (weak, nonatomic) IBOutlet UILabel *colorDay5;
@property (weak, nonatomic) IBOutlet UILabel *colorDay6;
@end

NS_ASSUME_NONNULL_END
