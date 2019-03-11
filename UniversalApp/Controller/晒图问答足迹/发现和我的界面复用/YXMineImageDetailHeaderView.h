//
//  YXMineImageDetailHeaderView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/23.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXMineImageDetailHeaderView : UIView
typedef void(^SegmentActionBlock)(NSInteger index);
@property (nonatomic,copy) SegmentActionBlock block;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleTimeLbl;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
@property (weak, nonatomic) IBOutlet UILabel *rightCountLbl;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lastSegmentControl;
- (IBAction)lastSegmentAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewHeight;
-(void)setUpWebView:(NSString *)htmlString;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
- (void)setUpSycleScrollView:(NSArray *)photoArray height:(CGFloat)height;
@end

NS_ASSUME_NONNULL_END
