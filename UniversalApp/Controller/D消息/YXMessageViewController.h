//
//  YXMessageViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "RootTableViewController.h"

@interface YXMessageViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UILabel *zanjb;
@property (weak, nonatomic) IBOutlet UILabel *fensijb;
@property (weak, nonatomic) IBOutlet UILabel *hdjb;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *stackView;
@property (weak, nonatomic) IBOutlet UIButton *tuisongBtn;
- (IBAction)tuisongAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *yiduBtn;

@end
