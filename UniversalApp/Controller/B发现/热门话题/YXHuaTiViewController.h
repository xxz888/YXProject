//
//  YXHuaTiViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/6.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHuaTiViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (nonatomic)BOOL isFaBuBool;//yes是发布进来的， no是发现界面进来的

@end

NS_ASSUME_NONNULL_END
