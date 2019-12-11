//
//  LoginViewController.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

@interface LoginViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UIButton *getMes_codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *moreLoginLbl;
@property (weak, nonatomic) IBOutlet UIStackView *moreLoginView;

@end
