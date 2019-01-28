//
//  YXMineImageCollectionViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/27.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXMineImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (nonatomic,strong) NSString *post_id;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIImageView *essayTitleImageView;
@property (weak, nonatomic) IBOutlet UILabel *essayNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *essayTimeLbl;
@end

NS_ASSUME_NONNULL_END
