//
//  YXPublishMoreTagsViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^returnTagString)(NSDictionary *);
@interface YXPublishMoreTagsViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIView *topview;
@property (nonatomic,copy) returnTagString tagBlock;
@end

NS_ASSUME_NONNULL_END
