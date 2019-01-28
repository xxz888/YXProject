//
//  YXMineAllImageTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YXMineAllImageTableViewCell;
typedef void(^clickZanBlock)(YXMineAllImageTableViewCell *);

@interface YXMineAllImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (nonatomic,strong) NSString *post_id;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;
- (IBAction)likeBtnAction:(id)sender;


@property (nonatomic,copy) clickZanBlock block;

@end

NS_ASSUME_NONNULL_END
