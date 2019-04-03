//
//  YXFindQuestionTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXMineAndFindBaseTableViewCell.h"
#import "IXAttributeTapLabel.h"
@class YXFindQuestionTableViewCell;
typedef void(^jumpDetailVC)(YXFindQuestionTableViewCell *);
NS_ASSUME_NONNULL_BEGIN

@interface YXFindQuestionTableViewCell : YXMineAndFindBaseTableViewCell


@property (nonatomic,strong) NSMutableDictionary * dataDic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *plLbl;

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (weak, nonatomic) IBOutlet UILabel *titleTagLbl1;
@property (weak, nonatomic) IBOutlet IXAttributeTapLabel *titleTagLbl2;


@property (weak, nonatomic) IBOutlet UIImageView *midImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView3;

@property (weak, nonatomic) IBOutlet UIButton *mapBtn;


@property (weak, nonatomic) IBOutlet UILabel *pl1NameLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl2NameLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl1ContentLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl2ContentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *addPlImageView;

typedef void(^clickImageBlock)(NSInteger);
@property (nonatomic,copy) clickImageBlock clickImageBlock;
-(void)setCellValue:(NSDictionary *)dic;


@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (nonatomic,copy) jumpDetailVC jumpDetailVC;



//回话 查看全部 添加评论    跳转详情
typedef void(^jumpDetail1VCBlock)(YXFindQuestionTableViewCell *);
- (IBAction)searchAllPlBtnAction:(id)sender;
@property (nonatomic,copy) jumpDetail1VCBlock jumpDetail1VCBlock;


//展开按钮
- (IBAction)openAction:(id)sender;
@property(nonatomic, copy) void (^showMoreTextBlock)(YXFindQuestionTableViewCell  *currentCell,NSMutableDictionary * dataDic);
///展开后的高度
+(CGFloat)cellMoreHeight:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textHeight;


//点赞
typedef void(^clickQuestionZanBlock)(YXFindQuestionTableViewCell *);
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
- (IBAction)likeBtnAction:(id)sender;
@property (nonatomic,copy) clickQuestionZanBlock zanblock1;


//分享
typedef void(^clickQuestionShareBlock)(YXFindQuestionTableViewCell *);
- (IBAction)shareAction:(id)sender;
@property (nonatomic,copy) clickQuestionShareBlock shareQuestionblock;


@property (weak, nonatomic) IBOutlet UILabel *talkCount;
@property (weak, nonatomic) IBOutlet UILabel *zanCount;
@property (weak, nonatomic) IBOutlet UILabel *shareCount;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imvHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pl1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pl2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plAllHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenter;




typedef void(^addPlFootActionBlock)(YXFindQuestionTableViewCell *);
- (IBAction)addPlAction:(id)sender;
@property (nonatomic,copy) addPlFootActionBlock addPlActionblock;


typedef void(^clickWenDaTagBlock)(NSString *);
@property (nonatomic,copy) clickWenDaTagBlock clickTagblock;
@end

NS_ASSUME_NONNULL_END
