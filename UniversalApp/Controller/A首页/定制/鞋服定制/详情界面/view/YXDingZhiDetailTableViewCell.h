//
//  YXDingZhiDetailTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/16.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^talkBlock)(void);
@interface YXDingZhiDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImg;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellTime;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *cellContent;
@property (weak, nonatomic) IBOutlet UIView *cellMiddleView;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *zanCount;
- (IBAction)zanAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *talkBtn;
- (IBAction)talkAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *talkCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentDetailHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailToTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellMiddleViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellMiddleViewToTopHeight;
-(void)setCellData:(NSDictionary *)dic;
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic;
@property(nonatomic,copy)talkBlock talkblock;
@end

NS_ASSUME_NONNULL_END
