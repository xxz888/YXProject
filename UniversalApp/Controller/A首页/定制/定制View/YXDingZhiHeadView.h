//
//  YXDingZhiHeadView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/11.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^tapView1Block)(NSString *);
typedef void(^tapView2Block)(NSString *);
typedef void(^tapView3Block)(NSString *);
typedef void(^tapView4Block)(void);

@interface YXDingZhiHeadView : UIView
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;

@property(copy,nonatomic)tapView1Block tapview1block;
@property(copy,nonatomic)tapView2Block tapview2block;
@property(copy,nonatomic)tapView3Block tapview3block;
@property(copy,nonatomic)tapView4Block tapview4block;

@end

NS_ASSUME_NONNULL_END
