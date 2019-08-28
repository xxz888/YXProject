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
@property (weak, nonatomic) IBOutlet UIButton *phoneLogin;
- (IBAction)phoneLoginAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
