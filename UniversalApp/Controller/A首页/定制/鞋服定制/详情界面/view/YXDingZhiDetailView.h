//
//  YXDingZhiDetailView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/13.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PingLunBlock)(void);
@interface YXDingZhiDetailView : UIView
- (IBAction)pinglunAction:(id)sender;
@property(nonatomic,copy)PingLunBlock pingLunBlock;
@end

NS_ASSUME_NONNULL_END
