//
//  YXFirstFindImageTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IXAttributeTapLabel.h"
#import "SDWeiXinPhotoContainerView.h"
NS_ASSUME_NONNULL_BEGIN
@interface YXFirstFindImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet IXAttributeTapLabel *wenzhangDetailLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wenzhangDetailHeight;
@property (nonatomic,assign) NSInteger tagId;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeight;
@property (weak, nonatomic) IBOutlet UIView *midView;
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic;
-(void)setCellValue:(NSDictionary *)dic;
@property (nonatomic,strong) NSMutableDictionary * dataDic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenter;
-(CGFloat)getTitleTagLblHeight:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeight;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UIImageView *onlyOneImv;
//点击头像
typedef void(^Click1ImageBlock)(NSInteger);
@property (nonatomic,copy) Click1ImageBlock clickImageBlock;
//分享
typedef void(^Click1ShareBlock)(NSInteger);
- (IBAction)shareAction:(id)sender;
@property (nonatomic,copy) Click1ShareBlock shareblock;
typedef void(^ClickTag1Block)(NSString *);
@property (nonatomic,copy) ClickTag1Block clickTagblock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeaderHeight;
@property (weak, nonatomic) IBOutlet UILabel *zanCount;
@property (weak, nonatomic) IBOutlet UILabel *talkCount;
- (IBAction)zanTalkAction:(id)sender;
typedef void(^GuanZhuBlock)();
@property (nonatomic,copy) GuanZhuBlock guanZhublock;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
- (IBAction)guanzhuAction:(id)sender;

typedef void(^clickInDetail)(NSInteger,NSInteger);
@property (nonatomic,copy) clickInDetail clickDetailblock;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
- (void)setUpSycleScrollView:(NSArray *)photoArray height:(CGFloat)height;
@property(nonatomic)SDCycleScrollView *cycleScrollView3;
@property (nonatomic)NSInteger tatolCount;
@property (weak, nonatomic) IBOutlet UIWebView *cellWebView;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *midViewHeight;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightWidth;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidth;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImvHeight;
    @property (weak, nonatomic) IBOutlet UIImageView *coverImV;
@property (weak, nonatomic) IBOutlet UIImageView *playImV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeViewHeight;
@property (weak, nonatomic) IBOutlet UIView *threeBtnView;
typedef void(^PlayBlock)(UITapGestureRecognizer *);
@property (nonatomic,copy) PlayBlock playBlock;
@property (weak, nonatomic) IBOutlet UIStackView *threeBtnStackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTopHeight;
@property (weak, nonatomic) IBOutlet UILabel *bottomPingLunLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toptop1Height;
@property (weak, nonatomic) IBOutlet UIButton *fenxiangBtn;
@property (weak, nonatomic) IBOutlet UIImageView *fenxiangImv;
+(CGFloat)cellAllImageHeight:(NSDictionary *)dic;
+(CGFloat)jisuanContentHeight:(NSDictionary *)dic;
+(CGFloat)cellTagViewHeight:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBottomHeight;

@end

NS_ASSUME_NONNULL_END
