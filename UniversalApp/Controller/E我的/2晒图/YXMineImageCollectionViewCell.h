//
//  YXMineImageCollectionViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/27.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YXMineImageCollectionViewCell;

typedef void(^clickZanBlock)(YXMineImageCollectionViewCell *);

@interface YXMineImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (nonatomic,strong) NSString *post_id;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;
- (IBAction)likeBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *zanLbl;
@property (weak, nonatomic) IBOutlet UILabel *userLbl;


@property (nonatomic,copy) clickZanBlock block;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIImageView *essayTitleImageView;
@property (weak, nonatomic) IBOutlet UILabel *essayNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *essayTimeLbl;
@end

NS_ASSUME_NONNULL_END
