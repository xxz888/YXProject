//
//  YXBindPhoneNextViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXBindPhoneNextViewController : RootViewController
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *nPhoneTf;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *nCodeTf;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *getMes_codeBtn;
@property (weak, nonatomic) IBOutlet UIButton * finishBtn;

- (IBAction)finishAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
