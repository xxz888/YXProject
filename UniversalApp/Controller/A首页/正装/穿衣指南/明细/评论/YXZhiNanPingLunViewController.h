//
//  YXZhiNanPingLunViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/11.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "YXBaseFaXianDetailViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^PinglunBlock)(NSString *);
@interface YXZhiNanPingLunViewController : YXBaseFaXianDetailViewController
@property (nonatomic,strong) NSDictionary * startStartDic;
@property (nonatomic,strong) NSString * startId;

@property (nonatomic,copy) PinglunBlock pinglunBlock;
@end

NS_ASSUME_NONNULL_END
