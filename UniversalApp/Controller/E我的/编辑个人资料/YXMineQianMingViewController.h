//
//  YXMineQianMingViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/2.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^qianmingBlock)(NSString *);

@interface YXMineQianMingViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIView *qianmingView;
@property (weak, nonatomic) IBOutlet UILabel *textCount;
@property(nonatomic, copy) qianmingBlock qianmingblock;//用户信息
@end

NS_ASSUME_NONNULL_END
