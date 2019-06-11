//
//  YXZhiNanDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXZhiNanDetailViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (nonatomic,strong) NSString * vcTitle;
@property (nonatomic,strong) NSMutableArray * startArray;
@property (nonatomic,assign) NSInteger startIndex;
@property (nonatomic,assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
