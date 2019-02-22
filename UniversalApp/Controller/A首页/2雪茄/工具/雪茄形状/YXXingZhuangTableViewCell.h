//
//  YXXingZhuangTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/14.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLGifImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXXingZhuangTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWid;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHei;

@end

NS_ASSUME_NONNULL_END
