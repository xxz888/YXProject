//
//  YXFaBuNewVCViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/6.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^closeAction)(void);
@interface YXFaBuNewVCViewController : RootViewController

@property (nonatomic, copy) closeAction block;
- (IBAction)shaituAction:(id)sender;
- (IBAction)wenzhangAction:(id)sender;
- (IBAction)closeAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
