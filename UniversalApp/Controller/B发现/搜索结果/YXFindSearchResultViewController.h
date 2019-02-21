//
//  YXFindSearchResultViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^clickSearchBarBlock)(NSString *);
@interface YXFindSearchResultViewController : RootViewController
@property (nonatomic,strong) NSString * searchText;
@property (nonatomic,copy) clickSearchBarBlock searchBlock;
@end

NS_ASSUME_NONNULL_END
