//
//  YXHomeLastDetailView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol clickMyTalkDelegate <NSObject>
-(void)clickMyTalkAction;
@end

typedef void(^SegmentActionBlock)(NSInteger index);
typedef void(^SearchAllActionBlock)(void);

@interface YXHomeLastDetailView : UIView
//重新赋值
-(void)againSetDetailView:(NSDictionary *)startDic  allDataDic:(NSDictionary *)allDataDic;
//六宫格图片
-(void)setSixPhotoView:(NSMutableArray *)imageArray;
//点击我的点评
@property (nonatomic,weak) id<clickMyTalkDelegate> delegate;
@property (nonatomic,copy)SegmentActionBlock block;
@property (nonatomic,copy)SearchAllActionBlock searchAllBlock;

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


@property (weak, nonatomic) IBOutlet UIButton *lastSearchAllBtn;
- (IBAction)lastSearchAllAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *lastSixPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *lastPinPaiLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastHuanJingLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastChangDuLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastXiangWeiLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lastSegmentControl;
- (IBAction)lastSegmentAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
