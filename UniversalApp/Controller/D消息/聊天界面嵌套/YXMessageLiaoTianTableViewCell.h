//
//  YXMessageLiaoTianTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXMessageLiaoTianTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ltImv;
@property (weak, nonatomic) IBOutlet UILabel *ltTitle;
@property (weak, nonatomic) IBOutlet UILabel *ltContent;
@property (weak, nonatomic) IBOutlet UILabel *ltTime;
@property (weak, nonatomic) IBOutlet UILabel *messageLbl;

@end

NS_ASSUME_NONNULL_END
