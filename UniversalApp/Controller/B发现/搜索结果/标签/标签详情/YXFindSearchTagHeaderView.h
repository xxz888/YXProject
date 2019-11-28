//
//  YXFindSearchTagHeaderView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/4/2.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^backvcBlock)(void);
typedef void(^fenxiangBlock)(void);
@interface YXFindSearchTagHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
- (IBAction)segmentAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
typedef void(^clickSegment)(NSInteger);
@property (nonatomic,copy) clickSegment block;
@property (nonatomic,copy) backvcBlock backvcblock;
@property (nonatomic,copy) fenxiangBlock fenxiangblock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoucangWidth;


typedef void(^shoucangBlock)(NSInteger);
- (IBAction)shoucangAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *shoucangImage;
@property (weak, nonatomic) IBOutlet UILabel *shoucangLabel;
@property (weak, nonatomic) IBOutlet UIButton *choucangBtn;
@property (nonatomic,copy) shoucangBlock shoucangblock;

@end

NS_ASSUME_NONNULL_END
