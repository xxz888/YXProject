//
//  YXFindSearchResultAllViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/12.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindViewController.h"
#import "YXMineAndFindBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXFindSearchResultAllViewController : YXMineAndFindBaseViewController
@property (nonatomic,strong) NSString *key;
-(void)requestFindAll:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
