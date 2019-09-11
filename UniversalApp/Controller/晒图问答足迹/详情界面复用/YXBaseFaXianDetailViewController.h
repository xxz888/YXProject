//
//  YXBaseFaXianDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/26.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "YXMineImageDetailHeaderView.h"
#import "YXHomeLastMyTalkView.h"
#import "UIView+SDAutoLayout.h"
#import "LEETheme.h"
#import "GlobalDefines.h"
#import "SDTimeLineTableHeaderView.h"
#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"
#import "YXHomeLastDetailView.h"
#import "YXHomeLastMyTalkView.h"
#import "XHStarRateView.h"
#import "ZInputToolbar.h"
#import "UIView+LSExtension.h"
#import "YXMineImageDetailHeaderView.h"
#import "BJNoDataView.h"

#import "UITableView+SDAutoTableViewCellHeight.h"
static CGFloat textFieldH = 40;
#define kTimeLineTableViewCellId @"SDTimeLineCell"

NS_ASSUME_NONNULL_BEGIN

@interface YXBaseFaXianDetailViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property(nonatomic,strong)NSDictionary * startDic;
@property (weak, nonatomic) IBOutlet UIButton *clickPingLunBtn;
@property (nonatomic,assign) CGFloat height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clickbtnHeight;

@property (nonatomic,assign) BOOL whereCome;
@property(nonatomic,strong)YXMineImageDetailHeaderView * lastDetailView;
@property(nonatomic,strong)YXHomeLastMyTalkView * lastMyTalkView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, copy) NSString *commentToUser;
@property (nonatomic, copy) NSString *commentToUserID;


@property (nonatomic, strong) ZInputToolbar *inputToolbar;

- (void)setupTextField;
-(void)initAllControl;
- (void)adjustTableViewToFitKeyboard;


@property (nonatomic,assign) CGFloat lastScrollViewOffsetY;
@property (nonatomic,assign) CGFloat totalKeybordHeight;
@property (nonatomic,assign) NSInteger segmentIndex;
@property (nonatomic,strong) NSMutableArray * pageArray;//因每个cell都要分页，所以page要根据评论id来分，不能单独写
@property (nonatomic,strong) NSMutableArray * imageArr;
-(void)requestNewList;

-(void)requestHotList;
-(void)delePingLun:(NSInteger)tag;
-(void)deleFather_PingLun:(NSString *)tag;
- (IBAction)clickPingLunAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *bottomZanBtn;
@property (weak, nonatomic) IBOutlet UILabel *bottomZanCount;
- (IBAction)backVCAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgShareBtn;
@property (weak, nonatomic) IBOutlet UIView *coustomNavView;

@end

NS_ASSUME_NONNULL_END
