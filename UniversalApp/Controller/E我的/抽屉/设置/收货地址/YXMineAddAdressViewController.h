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

@end

NS_ASSUME_NONNULL_END
