//
//  YXFindImageTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXMineAndFindBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface YXFindImageTableViewCell : YXMineAndFindBaseTableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleTagLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTagLblHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTagtextViewHeight;
@property (weak, nonatomic) IBOutlet UITextView *titleTagtextView;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;


@property (weak, nonatomic) IBOutlet UILabel *pl1NameLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl2NameLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl1ContentLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl2ContentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *addPlImageView;

@property (nonatomic,strong) NSMutableDictionary * dataDic;
@property (nonatomic,assign) BOOL whereCome;
//cell方法
-(void)setCellValue:(NSDictionary *)dic whereCome:(BOOL)whereCome;


@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

//回话 查看全部 添加评论    跳转详情
typedef void(^jumpDetailVCBlock)(YXFindImageTableViewCell *);
- (IBAction)searchAllPlBtnAction:(id)sender;
@property (nonatomic,copy) jumpDetailVCBlock jumpDetailVCBlock;



//点击头像
typedef void(^clickImageBlock)(NSInteger);
@property (nonatomic,copy) clickImageBlock clickImageBlock;

//爱心
typedef void(^clickImageZanBlock)(YXFindImageTableViewCell *);
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
- (IBAction)likeBtnAction:(id)sender;
@property (nonatomic,copy) clickImageZanBlock zanblock;


//分享
typedef void(^clickShareBlock)(YXFindImageTableViewCell *);
- (IBAction)shareAction:(id)sender;
@property (nonatomic,copy) clickShareBlock shareblock;


//展开按钮
- (IBAction)openAction:(id)sender;
@property(nonatomic, copy) void (^showMoreTextBlock)(YXFindImageTableViewCell  *currentCell,NSMutableDictionary * dataDic);
///展开后的高度
+(CGFloat)cellMoreHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome;
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;



@property (weak, nonatomic) IBOutlet UILabel *talkCount;
@property (weak, nonatomic) IBOutlet UILabel *zanCount;
@property (weak, nonatomic) IBOutlet UILabel *shareCount;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imvHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pl1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pl2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plAllHeight;
@property (weak, nonatomic) IBOutlet UILabel *plLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenter;



typedef void(^addPlActionBlock)(YXFindImageTableViewCell *);
- (IBAction)addPlAction:(id)sender;
@property (nonatomic) addPlActionBlock addPlActionblock;
@property (weak, nonatomic) IBOutlet UIView *lunBoView;
@property (weak, nonatomic) IBOutlet UILabel *rightCountLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewHeight;

@end

NS_ASSUME_NONNULL_END
