//
//  YXBindPhoneViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXBindPhoneViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UIButton *getMes_codeBtn;
@end

NS_ASSUME_NONNULL_END
