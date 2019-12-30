//
//  YXZhiNanPingLunViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/11.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^PinglunBlock)(NSString *);
@interface YXZhiNanPingLunViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
- (IBAction)backVcAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic,strong)NSDictionary * startDic;
@property(nonatomic,strong)NSMutableArray * dataArray;

- (IBAction)clickPingLunAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bottomMySelfImv;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
- (IBAction)zanAction:(id)sender;
@property(nonatomic,copy)PinglunBlock pinglunBlock;
@end

NS_ASSUME_NONNULL_END
