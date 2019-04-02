//
//  YXFindSearchResultTagViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindSearchResultAllViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXFindSearchResultTagViewController : HGBaseViewController
@property (nonatomic,strong) NSString *key;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) BOOL isEnlarge;
@property (nonatomic,strong) NSDictionary * startDic;

@end

NS_ASSUME_NONNULL_END
