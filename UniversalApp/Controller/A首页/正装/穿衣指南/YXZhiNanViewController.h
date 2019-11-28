//
//  YXZhiNanViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/17.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXZhiNanViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (nonatomic,strong) NSDictionary * startDic;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSDictionary * umDic;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

NS_ASSUME_NONNULL_END
