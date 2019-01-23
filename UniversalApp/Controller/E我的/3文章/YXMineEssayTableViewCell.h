//
//  YXMineEssayTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "TableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXMineEssayTableViewCell : TableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *essayTitleImageView;
@property (weak, nonatomic) IBOutlet UILabel *essayNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *essayTimeLbl;

@property (weak, nonatomic) IBOutlet UIWebView *essayWebView;

@end

NS_ASSUME_NONNULL_END
