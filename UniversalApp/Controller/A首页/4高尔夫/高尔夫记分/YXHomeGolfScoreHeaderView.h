//
//  YXHomeGolfScoreHeaderView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^clickDong)(NSMutableArray *);
@interface YXHomeGolfScoreHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (nonatomic,copy) clickDong clickDongBlock;
@end

NS_ASSUME_NONNULL_END
