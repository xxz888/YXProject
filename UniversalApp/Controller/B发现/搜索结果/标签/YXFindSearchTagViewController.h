//
//  YXFindSearchTagViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXFindSearchTagViewController : RootViewController
@property (nonatomic,strong) NSString *key;
-(void)requestFindAll_Tag:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
