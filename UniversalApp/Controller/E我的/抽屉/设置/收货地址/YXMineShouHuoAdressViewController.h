//
//  YXMineShouHuoAdressViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/9/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^backVCHaveParBlock)(NSDictionary *);
@interface YXMineShouHuoAdressViewController : RootViewController
@property(nonatomic,assign)BOOL whereCome;//YES 为商城界面
@property(nonatomic,copy)backVCHaveParBlock backVCHaveParblock;//YES 为商城界面

@end

NS_ASSUME_NONNULL_END
