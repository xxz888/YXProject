//
//  YXMessageThreeDetailViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface YXMessageThreeDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *lbl1Tag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbl1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbl2Height;
@property (weak, nonatomic) IBOutlet UIButton *guanZhuBtn;
- (IBAction)guanZhuAction:(id)sender;
typedef void(^guanzhuAction)(YXMessageThreeDetailViewCell *);
@property (nonatomic,copy) guanzhuAction gzBlock;
@property (nonatomic,strong) NSString * userId;


typedef void(^titleImgAction)(YXMessageThreeDetailViewCell *);
@property (nonatomic,copy) titleImgAction imgBlock;
@end

NS_ASSUME_NONNULL_END
