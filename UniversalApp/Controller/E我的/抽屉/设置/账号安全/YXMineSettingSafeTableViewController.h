//
//  YXMineSettingSafeTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/25.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXMineSettingSafeTableViewController : RootTableViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *wxAccTf;
@property (weak, nonatomic) IBOutlet UITextField *wbTf;
@property (weak, nonatomic) IBOutlet UITextField *qqTf;

@end

NS_ASSUME_NONNULL_END
