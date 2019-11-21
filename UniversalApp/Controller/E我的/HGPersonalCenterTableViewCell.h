//
//  HGPersonalCenterTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/18.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBGroupAndStreamView.h"
#import "SDWeiXinPhotoContainerView.h"
#import "UIImage+ImgSize.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGPersonalCenterTableViewCell : UITableViewCell
//高度不变的
@property (weak, nonatomic) IBOutlet UILabel *cellDayLbl;
@property (weak, nonatomic) IBOutlet UILabel *cellRiQiLbl;
- (IBAction)fenxiangAction:(id)sender;
- (IBAction)pinglunAction:(id)sender;
- (IBAction)dianzanAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *cellDianzanLbl;
@property (weak, nonatomic) IBOutlet UILabel *cellPingLunLbl;
//高度变的
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellContentLblHeight;
@property (weak, nonatomic) IBOutlet UILabel *cellContentLbl;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTagViewToTopSpaceHeight;
@property (weak, nonatomic) IBOutlet UIView *cellMidView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellMidViewHeight;

@property (weak, nonatomic) IBOutlet UIView *cellTagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTagViewHeight;

-(void)setCellData:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (strong, nonatomic) CBGroupAndStreamView * cbGroupAndStreamView;
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic;

@property (strong, nonatomic) NSDictionary *dataDic;

@property (strong, nonatomic) SDWeiXinPhotoContainerView *picContainerView;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UIImageView *coverImv;
@property (weak, nonatomic) IBOutlet UIImageView *playImv;
typedef void(^PlayBlock)(UITapGestureRecognizer *);
@property (nonatomic,copy) PlayBlock playBlock;

typedef void(^clickInDetail)(NSInteger,NSInteger);
@property (nonatomic,copy) clickInDetail clickDetailblock;



typedef void(^ClickTag1Block)(NSString *);
@property (nonatomic,copy) ClickTag1Block clickTagblock;
+(CGFloat)cellAllImageHeight:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
