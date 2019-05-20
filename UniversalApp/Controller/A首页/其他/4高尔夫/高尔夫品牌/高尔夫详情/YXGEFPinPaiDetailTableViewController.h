//
//  YXGEFPinPaiDetailTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/17.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXGEFPinPaiDetailTableViewController : RootViewController
@property(nonatomic,strong)NSMutableDictionary * dicData;
@property(nonatomic,strong)NSMutableDictionary * dicStartData;


@property (weak, nonatomic) IBOutlet UITableView *yxTableView;

@end

NS_ASSUME_NONNULL_END
