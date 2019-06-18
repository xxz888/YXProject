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
@property (nonatomic,strong) NSMutableArray * startArray;
@property (nonatomic,assign) NSInteger smallIndex;
@property (nonatomic,assign) NSInteger bigIndex;

@property (weak, nonatomic) IBOutlet UIImageView *collImgView;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
    
@end

NS_ASSUME_NONNULL_END
