//
//  YXMineAddAdressViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXMineAddAdressViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIButton *selectAdressBtn;
- (IBAction)selectAdressAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *detailAdressView;
@property (weak, nonatomic) IBOutlet UITextField *adName;
@property (weak, nonatomic) IBOutlet UITextField *adPhone;
@property (nonatomic,strong) NSDictionary * addressDic;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end

NS_ASSUME_NONNULL_END
