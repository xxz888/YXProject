//
//  YXHomePeiJianLastView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/4/14.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol clickMyTalkDelegate <NSObject>
-(void)clickMyTalkAction;
@end

typedef void(^SegmentActionBlock)(NSInteger index);
typedef void(^SearchAllActionBlock)(void);
typedef void(^fixBoxActionBlock)(NSInteger index);
@interface YXHomePeiJianLastView : UIView

@property (nonatomic,strong) NSMutableArray * listData;

//重新赋值
-(void)againSetDetailView:(NSDictionary *)startDic;
-(void)fiveStarViewUIAllDataDic:(NSDictionary *)allDataDic;
-(void)fiveStarViewUIAllDataDic_GeRenFen:(NSDictionary *)allDataDic;
-(void)fiveStarViewUIAllDataDic_PingJunFen:(NSDictionary *)allDataDic;
//六宫格图片
-(void)setSixPhotoView:(NSMutableArray *)imageArray;
//点击我的点评
@property (nonatomic,weak) id<clickMyTalkDelegate> delegate;
@property (nonatomic,copy) fixBoxActionBlock fixBlock;
@property (nonatomic,copy)SegmentActionBlock block;
@property (nonatomic,copy)SearchAllActionBlock searchAllBlock;
@property (weak, nonatomic) IBOutlet UIView *scoreView;

@property (weak, nonatomic) IBOutlet UIImageView *lastImageView;
@property (weak, nonatomic) IBOutlet UILabel *lastTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastPrice1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *lastPrice2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *lastPrice3Lbl;
@property (weak, nonatomic) IBOutlet UIButton *lastMyTalkBtn;
- (IBAction)lastMyTalkAction:(id)sender;



@property (weak, nonatomic) IBOutlet UILabel *lastAllScoreLbl;
@property (weak, nonatomic) IBOutlet UIView *lastAllScoreFiveView;

@property (weak, nonatomic) IBOutlet UIView *lastWaiGuanFiveView;
@property (weak, nonatomic) IBOutlet UIView *lastRanShaoFiveView;
@property (weak, nonatomic) IBOutlet UIView *lastKouGanFiveView;
@property (weak, nonatomic) IBOutlet UIView *lastXiangWeiFiveView;
@property (weak, nonatomic) IBOutlet UILabel *xingzhuangLbl;

@property (weak, nonatomic) IBOutlet UILabel *zhongwenName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchAllRowHeight;
@property (weak, nonatomic) IBOutlet UIView *searchAllView;

@property (weak, nonatomic) IBOutlet UIButton *lastSearchAllBtn;
- (IBAction)lastSearchAllAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listViewHeight;
@property (weak, nonatomic) IBOutlet UIView *lisetView;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (weak, nonatomic) IBOutlet UIView *lastSixPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *lastPinPaiLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastHuanJingLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastChangDuLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastXiangWeiLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lastSegmentControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sixViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *nongduLbl;
- (IBAction)lastSegmentAction:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *tuijianAll;

@property (weak, nonatomic) IBOutlet UILabel *lbl1score;
@property (weak, nonatomic) IBOutlet UILabel *lbl2score;
@property (weak, nonatomic) IBOutlet UILabel *lbl3score;
@property (weak, nonatomic) IBOutlet UILabel *lbl1people;
@property (weak, nonatomic) IBOutlet UILabel *lbl2people;
@property (weak, nonatomic) IBOutlet UILabel *lbl3people;
@property (weak, nonatomic) IBOutlet UIProgressView *progress1;
@property (weak, nonatomic) IBOutlet UIProgressView *porgress2;
@property (weak, nonatomic) IBOutlet UIProgressView *progress3;
@property (nonatomic,assign) BOOL PeiJianOrPinPai;//NO代表品牌 YES代表配件
@property (weak, nonatomic) IBOutlet UILabel *store1;
@property (weak, nonatomic) IBOutlet UILabel *store2;
@property (weak, nonatomic) IBOutlet UILabel *store3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canshuLblHeight;
@property (weak, nonatomic) IBOutlet UILabel *canshuLbl;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIWebView *yxWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
@end

NS_ASSUME_NONNULL_END
