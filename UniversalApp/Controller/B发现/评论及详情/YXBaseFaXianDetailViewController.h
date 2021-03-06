//
//  YXBaseFaXianDetailViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/26.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "ZInputToolbar.h"
#import "UIView+LSExtension.h"

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
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
//@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
//@property (nonatomic, copy) NSString *commentToUser;
//@property (nonatomic, copy) NSString *commentToUserID;

@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
- (IBAction)guanzhuAction:(id)sender;

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@property (weak, nonatomic) IBOutlet UIButton *bottomZanBtn;
@property (weak, nonatomic) IBOutlet UILabel *bottomZanCount;
- (IBAction)backVCAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgShareBtn;
@property (weak, nonatomic) IBOutlet UIView *coustomNavView;
- (void)guanzhuAction;
@property (weak, nonatomic) IBOutlet UIImageView *zanImgv;

@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *titleTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeStackViewLeftMagin;
@property (weak, nonatomic) IBOutlet UIView *pinglunView1;
@property (weak, nonatomic) IBOutlet UIView *pinglunView2;

@property (weak, nonatomic) IBOutlet UIImageView *pinglunView2TitleImv;
@property (weak, nonatomic) IBOutlet UIStackView *threeStackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeStackViewWidth;
- (void)saveImage:(UMSocialPlatformType)umType;
-(void)clickUserImageView:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
