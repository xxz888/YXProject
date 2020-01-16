//
//  YXNewLoginViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/8/28.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXNewLoginViewController : RootViewController

@property (weak, nonatomic) IBOutlet UIView *wxLogin;
@property (weak, nonatomic) IBOutlet UIStackView *moreLoginView;
@property (weak, nonatomic) IBOutlet UILabel *moreLoginLbl;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
- (IBAction)getSms_CodeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *getMes_codeBtn;

@end

NS_ASSUME_NONNULL_END
