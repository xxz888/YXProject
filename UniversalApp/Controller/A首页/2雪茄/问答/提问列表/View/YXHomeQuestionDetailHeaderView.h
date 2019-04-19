//
//  YXHomeQuestionDetailHeaderView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/16.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeQuestionDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *oneLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIView *totalImage;
@property (weak, nonatomic) IBOutlet UILabel *twoLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoLblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imvHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionTitleHeight;

@end

NS_ASSUME_NONNULL_END
