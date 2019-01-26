//
//  YXMineImageTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "TableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@interface YXMineImageTableViewCell : TableViewCell
typedef void(^clickZan)(YXMineImageTableViewCell *);
typedef void(^clickImage)(NSInteger);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIImageView *essayTitleImageView;
@property (weak, nonatomic) IBOutlet UILabel *essayNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *essayTimeLbl;


@property (weak, nonatomic) IBOutlet UILabel *mineImageLbl;
@property (weak, nonatomic) IBOutlet UIButton *mineImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *mineTimeLbl;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (nonatomic,strong) NSString *post_id;
@property (nonatomic) BOOL isZan;
@property (nonatomic,copy) clickZan block;
@property (nonatomic,copy) clickImage clickImageBlock;
@property (weak, nonatomic) IBOutlet UIView *midView;

- (IBAction)likeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;
@property (weak, nonatomic) IBOutlet UIWebView *midWebView;

@end

NS_ASSUME_NONNULL_END
