//
//  YXFindSearchResultUsersViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXFindSearchResultUsersViewController : RootViewController
@property (nonatomic,assign) BOOL whereCome; //yes 为标签 no为用户
@property (nonatomic,strong) NSString *key;
@end

NS_ASSUME_NONNULL_END
