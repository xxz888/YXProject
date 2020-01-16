//
//  YXNewLoginMessageViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2020/1/15.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXNewLoginMessageViewController : RootViewController
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
- (IBAction)backVcAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *codeView;
- (IBAction)getSms_CodeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *getMes_codeBtn;
@property (nonatomic,strong) NSString * phone;

@end

NS_ASSUME_NONNULL_END
