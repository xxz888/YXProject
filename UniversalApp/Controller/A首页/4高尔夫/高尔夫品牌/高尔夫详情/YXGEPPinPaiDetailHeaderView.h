//
//  YXGEPPinPaiDetailHeaderView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/18.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ClickGuanZhuBtnDelegate <NSObject>
-(void)clickGuanZhuAction:(UIButton *)btn;
@end
@interface YXGEPPinPaiDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *section1ImageView;
@property (weak, nonatomic) IBOutlet UILabel *section1TitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *section1countLbl;
@property (weak, nonatomic) IBOutlet UIButton *section1GuanZhuBtn;
- (IBAction)section1GuanZhuAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *section1TextView;

- (IBAction)segmentCon:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bigSegment;
@property (weak, nonatomic) IBOutlet UIView *smallView;
@property (nonatomic,weak) id<ClickGuanZhuBtnDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
