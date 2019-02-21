//
//  YXHomeXueJiaQuestionDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/16.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaQuestionDetailViewController.h"
#import "KeyBoardTableView.h"
#import "SDTimeLineTableHeaderView.h"
#import "SDTimeLineRefreshHeader.h"
#import "SDTimeLineRefreshFooter.h"
#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#import "UIView+SDAutoLayout.h"
#import "LEETheme.h"
#import "GlobalDefines.h"
#import "YXHomeQuestionDetailHeaderView.h"
#import "HCInputBar.h"

#define kTimeLineTableViewCellId @"SDTimeLineCell"

static CGFloat textFieldH = 0;
@interface YXHomeXueJiaQuestionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDTimeLineCellDelegate, UITextFieldDelegate>{
    SDTimeLineRefreshFooter *_refreshFooter;
    SDTimeLineRefreshHeader *_refreshHeader;
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;
    NSInteger _segmentIndex;
    NSMutableArray * _pageArray;//因每个cell都要分页，所以page要根据评论id来分，不能单独写
}
@property (strong, nonatomic) HCInputBar *inputBar;
@property (strong, nonatomic) UITextView *textWindow;
@property (weak, nonatomic) IBOutlet KeyBoardTableView *yxTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic)YXHomeQuestionDetailHeaderView * headerView;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, copy) NSString *commentToUser;
@property (nonatomic, strong) NSMutableDictionary * pardic;;
@property (nonatomic, strong) MMImageListView *imageListView;

@end

@implementation YXHomeXueJiaQuestionDetailViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    //初始化所有的控件
    [self initAllControl];
    
    
    [self addRefreshView:self.yxTableView];
    [self requestAnserList];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
#pragma mark ========== 请求回答列表 ==========
-(void)requestAnserList{
    NSString * par = [NSString stringWithFormat:@"%@/%@",self.moment.startId,NSIntegerToNSString(self.requestPage)];
    //获取回答列表
    kWeakSelf(self);
    [YX_MANAGER requestAnswerListGET:par success:^(id object) {
        if ([object count] != 0) {
            weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
            weakself.dataArray = [NSMutableArray arrayWithArray:[weakself creatModelsWithCount:weakself.dataArray]];
            [weakself refreshTableView];
            [weakself.inputBar.inputView resignFirstResponder];
        }else{
            [weakself.yxTableView.mj_footer endRefreshing];
            [weakself.yxTableView.mj_header endRefreshing];
        }
 
    }];
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestAnserList];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestAnserList];
}
-(void)commonAction{
    
}
#pragma mark ========== 发布回答 ==========
-(void)requestFaBuHuiDa:(NSMutableDictionary *)dic{
    [dic setValue:self.moment.startId forKey:@"question_id"];
    if (!dic[@"question_id"]) {
        [QMUITips showError:@"问题不存在,请返回重新进入" inView:self.yxTableView hideAfterDelay:1];
        return;
    }else if (!dic[@"answer"] || [dic[@"answer"] length] < 0){
        [QMUITips showError:@"请输入回答" inView:self.yxTableView hideAfterDelay:1];
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestFaBuHuiDaPOST:dic success:^(id object) {
        [weakself requestAnserList];
    }];
}

#pragma mark ========== 发布子回答 ==========
-(void)requestFaBuHuiDaChild:(NSMutableDictionary *)dic{
    if (!dic[@"answer_id"]) {
        [QMUITips showError:@"问题不存在,请返回重新进入" inView:self.yxTableView hideAfterDelay:1];
        return;
    }else if (!dic[@"answer"] || [dic[@"answer"] length] < 0){
        [QMUITips showError:@"请输入回答" inView:self.yxTableView hideAfterDelay:1];
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestFaBuHuiDa_childPOST:dic success:^(id object) {
        [weakself requestAnserList];
    }];
}

-(void)refreshTableView{
    if (_currentEditingIndexthPath) {
        [self.yxTableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self.yxTableView reloadData];
    }
}
-(void)initAllControl{
    kWeakSelf(self);
    self.title = @"回复";
    _segmentIndex = 0;
    _dataArray = [[NSMutableArray alloc]init];
    _pageArray = [[NSMutableArray alloc]init];
    
    _pardic = [[NSMutableDictionary alloc]init];
    [self.yxTableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource = self;
    self.yxTableView.estimatedRowHeight = 0;
    self.yxTableView.estimatedSectionHeaderHeight = 0;
    self.yxTableView.estimatedSectionFooterHeight = 0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //添加用于显示表情和文字的textview
    [self.view addSubview:self.textWindow];
    //添加输入框键盘模块
    [self.view addSubview:self.inputBar];
    
  

    
    //点击键盘发送按钮，开始发布回答
    self.inputBar.block = ^(NSString *contents) {
        [weakself.pardic removeAllObjects];
        if (weakself.isReplayingComment) {
            
            
            SDTimeLineCellModel *model = weakself.dataArray[weakself.currentEditingIndexthPath.row];
            SDTimeLineCellCommentItemModel * itemModel;
            for (SDTimeLineCellCommentItemModel * oldItemModel in model.commentItemsArray) {
                if ([oldItemModel.firstUserName isEqualToString:weakself.commentToUser]) {
                    itemModel = oldItemModel;
                }
            }
            int farther_id = 0;
            if ([itemModel.firstUserName isEqualToString:weakself.commentToUser]) {
                farther_id = [itemModel.firstUserId intValue];
            }
            if ([itemModel.secondUserName isEqualToString:weakself.commentToUser]) {
                farther_id = [itemModel.secondUserId intValue];
            }
            
            
            [weakself.pardic setValue:model.id forKey:@"answer_id"];
            [weakself.pardic setValue:contents forKey:@"answer"];
            [weakself.pardic setValue:itemModel.firstUserId forKey:@"aim_id"];
            [weakself.pardic setValue:itemModel.firstUserName  forKey:@"aim_name"];
  
            [weakself requestFaBuHuiDaChild:weakself.pardic];
        }else{
            [weakself.pardic setValue:contents forKey:@"answer"];
            [weakself requestFaBuHuiDa:weakself.pardic];
        }

    };
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //添加分隔线颜色设置
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXHomeQuestionDetailHeaderView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    self.headerView.frame = CGRectMake(0, 0, KScreenWidth, !AxcAE_IsiPhoneX ? 300 : 220);
    
    self.headerView.titleImageView.layer.masksToBounds = YES;
    self.headerView.titleImageView.layer.cornerRadius = self.headerView.titleImageView.frame.size.width / 2.0;
    // 图片区
    _imageListView = [[MMImageListView alloc] initWithFrame:CGRectZero];
    [self.headerView.totalImage addSubview:_imageListView];
    self.headerView.twoLblHeight.constant = [ShareManager inTextFieldOutDifColorView:self.moment.detailText];
    [ShareManager setLineSpace:9 withText:self.moment.detailText inLabel:self.headerView.twoLbl tag:@""];

    NSString * str = [(NSMutableString *)self.moment.photo replaceAll:@" " target:@"%20"];
    [self.headerView.titleImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.headerView.titleLbl.text = self.moment.userName;
    self.headerView.timeLbl.text = [ShareManager updateTimeForRow:self.moment.time];
    self.headerView.oneLbl.text = self.moment.text;
    NSString * str0 = [(NSMutableString *)self.moment.imageListArray[0] replaceAll:@" " target:@"%20"];
    NSString * str1 = [(NSMutableString *)self.moment.imageListArray[1] replaceAll:@" " target:@"%20"];
    NSString * str2 = [(NSMutableString *)self.moment.imageListArray[2] replaceAll:@" " target:@"%20"];
    Moment * moment = [[Moment alloc]init];
    moment.imageListArray = [NSMutableArray arrayWithObjects:str0,str1, str2, nil];
    moment.singleWidth = 500;
    moment.singleHeight = 315;
    moment.fileCount = 3;
    _imageListView.moment = moment;
    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  260 - 30 + [ShareManager inTextFieldOutDifColorView:self.moment.detailText];
}
-(CGSize)cellAutoHeight:(NSString *)string {
    //展开后得高度(计算出文本内容的高度+固定控件的高度)
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [string boundingRectWithSize:CGSizeMake(KScreenWidth- 20, 100000) options:option attributes:attribute context:nil].size;
    return size;
}
#pragma mark ========== 请求子回答列表 ==========

-(void)requestAnserChildList:(NSString *)farther_id page:(NSString *)page{

    kWeakSelf(self);
    NSString * string = [NSString stringWithFormat:@"%@/%@",farther_id,page];
    [YX_MANAGER requestAnswer_childListGET:string success:^(id object) {
        
        if ([object count] == 0) {
            [QMUITips showInfo:@"没有更多评论了" detailText:@"" inView:weakself.yxTableView hideAfterDelay:1];
            return ;
        }
        
        SDTimeLineCellModel *model = self.dataArray[_currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.commentItemsArray];
        //判断评论数组是否添加过新数据，如果添加过就不添加了
        
        for (NSDictionary * dic in object) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            if ([dic[@"aim_id"] integerValue] != 0) {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName = kGetString(dic[@"user_name"]);
                commentItemModel.secondUserName = kGetString(dic[@"aim_name"]);
                commentItemModel.secondUserId = kGetString(dic[@"aim_id"]);
                commentItemModel.commentString = kGetString(dic[@"answer"]);
                
                self.isReplayingComment = YES;
            } else {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName =kGetString(dic[@"user_name"]);
                commentItemModel.commentString = kGetString(dic[@"answer"]);
            }
            BOOL ishave = NO;
            for (SDTimeLineCellCommentItemModel * oldCommentItemModel in model.commentItemsArray) {
                if ([oldCommentItemModel.firstUserId integerValue] == [commentItemModel.firstUserId integerValue] &&
                    [oldCommentItemModel.firstUserName isEqualToString:commentItemModel.firstUserName]   &&
                    [oldCommentItemModel.commentString isEqualToString:commentItemModel.commentString]
                    ) {
                    ishave = YES;
                }else{
                    ishave = NO;
                    break;
                }
            }
            if (ishave) {
                
            }else{
                [temp addObject:commentItemModel];
                model.commentItemsArray = [temp copy];
            }
        }
        [self.yxTableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}
#pragma mark ========== tableview数据 ==========
- (NSArray *)creatModelsWithCount:(NSArray *)formalArray{
    [_pageArray removeAllObjects];
    NSMutableArray *resArr = [NSMutableArray new];
    for (int i = 0; i < formalArray.count; i++) {
        SDTimeLineCellModel *model = [SDTimeLineCellModel new];
        NSMutableDictionary * pageDic = [[NSMutableDictionary alloc]init];
        model.iconName = formalArray[i][@"user_photo"];
        model.name = [formalArray[i][@"user_name"] append:@":"];
        model.msgContent = formalArray[i][@"answer"];
        model.id =  kGetString(formalArray[i][@"id"]);
        
        [pageDic setValue:@([model.id intValue]) forKey:@"id"];
        [pageDic setValue:@(0) forKey:@"page"];
        [_pageArray addObject:pageDic];
        
        // 模拟随机评论数据
        NSMutableArray *tempComments = [NSMutableArray new];
        NSArray * child_listArray =  [NSArray arrayWithArray:formalArray[i][@"child"]];
        for (int i = 0; i < [child_listArray count]; i++) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            commentItemModel.firstUserName = [kGetString(child_listArray[i][@"user_name"]) append:@":"];
            commentItemModel.firstUserId = kGetString(child_listArray[i][@"user_id"]);
            if (child_listArray[i][@"aim_id"] != 0) {
                commentItemModel.secondUserName = [kGetString(child_listArray[i][@"aim_name"]) append:@":"];
                commentItemModel.secondUserId = kGetString(child_listArray[i][@"aim_id"]);
            }
            commentItemModel.commentString = child_listArray[i][@"answer"];
            [tempComments addObject:commentItemModel];
        }
        model.commentItemsArray = [tempComments copy];
        [resArr addObject:model];
    }
    return [resArr copy];
}
#pragma mark ========== tableview代理和所有方法 ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    cell.indexPath = indexPath;
    cell.nameLable.textColor = KBlackColor;
    cell.contentLabel.textColor = KDarkGaryColor;
//    cell.nameLable.font = [UIFont systemFontOfSize:14];
//    cell.contentLabel.font =[UIFont systemFontOfSize:14];
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            SDTimeLineCellModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.yxTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [cell setDidClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, SDTimeLineCell * cell) {
            weakSelf.inputBar.placeHolder = [NSString stringWithFormat:@"  回复：%@", commentId];
            weakSelf.currentEditingIndexthPath = cell.indexPath;
            [weakSelf.inputBar.inputView becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentId;            
        }];
        
        cell.delegate = self;
    }
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];

    cell.model = self.dataArray[indexPath.row];
    
    cell.iconView.hidden = cell.starView.hidden = cell.moreButton.hidden = cell.zanButton.hidden =
    cell.huiFuButton.hidden = cell.commentView.likeStringLabel.hidden = cell.timeLabel.hidden = YES;
    cell.iconView.sd_layout.widthIs(0);
    if (cell.model.commentItemsArray.count == 0) {
        cell.showMoreCommentBtn.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
//    return 30;
    
    SDTimeLineCellModel * model = self.dataArray[indexPath.row];
    if (model.commentItemsArray.count == 0 ) {
        
        return [self.yxTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]] - 40;
    }
    return [self.yxTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
    
}
- (CGFloat)cellContentViewWith{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
#pragma mark ========== 点击跟多评论按钮 ==========
-(void)showMoreComment:(UITableViewCell *)cell{
    _currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[_currentEditingIndexthPath.row];
    NSMutableArray * copyArray = [NSMutableArray arrayWithArray:_pageArray];
    for (NSDictionary * dic in copyArray) {
        if ([dic[@"id"] intValue] == [model.id intValue]) {
            [dic setValue:@([dic[@"page"] intValue]+1) forKey:@"page"];
            kWeakSelf(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself requestAnserChildList:model.id page:kGetString(dic[@"page"])];
            });
        }
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   /* [_inputBar.inputView becomeFirstResponder];
    _currentEditingIndexthPath = indexPath;
    SDTimeLineCellModel *model = self.dataArray[_currentEditingIndexthPath.row];
    self.commentToUser = model.name;
    */
}



- (IBAction)startInputTextAction:(id)sender {

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (HCInputBar *)inputBar {
    if (!_inputBar) {
        _inputBar = [[HCInputBar alloc]initWithStyle:DefaultInputBarStyle];
        _inputBar.keyboard.showAddBtn = NO;
        [_inputBar.keyboard addBtnClicked:^{
            NSLog(@"我点击了添加按钮");
        }];
        _inputBar.placeHolder = @"点击评论";
    }
    return _inputBar;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_inputBar.inputView resignFirstResponder];
}
@end
