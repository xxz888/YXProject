//
//  YXMineEssayDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/24.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineEssayDetailViewController.h"
#import "YXHomeLastDetailView.h"
#import "YXHomeLastMyTalkView.h"
#import "XHStarRateView.h"

#import "YXMineImageDetailHeaderView.h"

#import "SDTimeLineTableHeaderView.h"
#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#import "UIView+SDAutoLayout.h"
#import "LEETheme.h"
#import "GlobalDefines.h"

#define kTimeLineTableViewCellId @"SDTimeLineCell"

static CGFloat textFieldH = 40;


@interface YXMineEssayDetailViewController ()<UITableViewDelegate,UITableViewDataSource,clickMyTalkDelegate,SDTimeLineCellDelegate, UITextFieldDelegate>{
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;
    NSInteger _segmentIndex;
    NSMutableArray * _pageArray;//因每个cell都要分页，所以page要根据评论id来分，不能单独写
}
    @property(nonatomic,strong)YXMineImageDetailHeaderView * lastDetailView;
    @property(nonatomic,strong)YXHomeLastMyTalkView * lastMyTalkView;
    @property (nonatomic, strong) NSMutableArray *dataArray;
    @property (nonatomic, strong) UITextField *textField;
    @property (nonatomic, assign) BOOL isReplayingComment;
    @property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
    @property (nonatomic, copy) NSString *commentToUser;
@end

@implementation YXMineEssayDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    //初始化所有的控件
    [self initAllControl];
    [self requestNewList];

}
-(void)initAllControl{
    kWeakSelf(self);
    self.title = @"文章详情";
    _segmentIndex = 0;
    _dataArray = [[NSMutableArray alloc]init];
    _pageArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    self.yxTableView.estimatedRowHeight = 0;
    self.yxTableView.estimatedSectionHeaderHeight = 0;
    self.yxTableView.estimatedSectionFooterHeight = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    //添加分隔线颜色设置
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXMineImageDetailHeaderView" owner:self options:nil];
    self.lastDetailView = [nib objectAtIndex:0];
    self.lastDetailView.frame = CGRectMake(0, 0, KScreenWidth, 485);
    self.yxTableView.tableHeaderView = self.lastDetailView;
    self.lastDetailView.titleLbl.text = self.startDic[@"user_name"];
    [self.lastDetailView setUpWebView:self.startDic[@"essay"]];
    self.lastDetailView.titleImageView.layer.masksToBounds = YES;
    self.lastDetailView.titleImageView.layer.cornerRadius = self.lastDetailView.titleImageView.frame.size.width / 2.0;
    self.lastDetailView.titleTimeLbl.text = [ShareManager timestampSwitchTime:[self.startDic[@"publish_time"] longLongValue] andFormatter:@""];
    
    
    
    
    
    self.clickPingLunBtn.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    self.clickPingLunBtn.layer.borderWidth = 1;
    //点击segment
    self.lastDetailView.block = ^(NSInteger index) {
        index == 0 ? [weakself requestNewList] : [weakself requestHotList];
        _segmentIndex = index;
    };
    [self setupTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
}
#pragma mark ========== 获取文章评论列表 ==========
-(void)requestNewList{
    kWeakSelf(self);
    //请求评价列表 最新评论列表
    [YX_MANAGER requestessay_comment:[self getParamters:@"1" page:@"1"] success:^(id object) {
        [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"b2"];
        weakself.dataArray = [NSMutableArray arrayWithArray:[weakself creatModelsWithCount:object]];
        [weakself refreshTableView];
    }];
}
-(void)requestHotList{
    kWeakSelf(self);
    //请求评价列表 最热评论列表
    [YX_MANAGER requestessay_comment:[self getParamters:@"2" page:@"1"] success:^(id object) {
        weakself.dataArray = [NSMutableArray arrayWithArray:[weakself creatModelsWithCount:object]];
        [weakself refreshTableView];
    }];
}
-(void)refreshTableView{
    if (_currentEditingIndexthPath) {
        [self.yxTableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self.yxTableView reloadData];
    }
}
#pragma mark ========== 评论子评论 ==========
-(void)requestpost_comment_child:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestessay_comment_childPOST:dic success:^(id object) {
        _segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
#pragma mark ========== 更多评论 ==========
-(void)requestMoreCigar_comment_child:(NSString *)farther_id page:(NSString *)page{
    kWeakSelf(self);
    NSString * string = [NSString stringWithFormat:@"%@/%@",farther_id,page];
    [YX_MANAGER requestessay_comment_child:string success:^(id object) {
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
                commentItemModel.commentString = kGetString(dic[@"comment"]);
                
                self.isReplayingComment = YES;
            } else {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName =kGetString(dic[@"user_name"]);
                commentItemModel.commentString = kGetString(dic[@"comment"]);
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
        model.name = formalArray[i][@"user_name"];
        model.msgContent = formalArray[i][@"comment"];
        model.commontTime = [formalArray[i][@"update_time"] integerValue];
        model.praise = kGetString(formalArray[i][@"praise_number"]);
        model.id =  kGetString(formalArray[i][@"id"]);
        model.postid = kGetString(formalArray[i][@"postid"]);
        [pageDic setValue:@([model.id intValue]) forKey:@"id"];
        [pageDic setValue:@(0) forKey:@"page"];
        [_pageArray addObject:pageDic];
        
        // 模拟随机评论数据
        NSMutableArray *tempComments = [NSMutableArray new];
        NSArray * child_listArray =  [NSArray arrayWithArray:formalArray[i][@"child_list"]];
        for (int i = 0; i < [child_listArray count]; i++) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            commentItemModel.firstUserName = kGetString(child_listArray[i][@"user_name"]);
            commentItemModel.firstUserId = kGetString(child_listArray[i][@"user_id"]);
            if (child_listArray[i][@"aim_id"] != 0) {
                commentItemModel.secondUserName = kGetString(child_listArray[i][@"aim_name"]);
                commentItemModel.secondUserId = kGetString(child_listArray[i][@"aim_id"]);
            }
            commentItemModel.commentString = child_listArray[i][@"comment"];
            [tempComments addObject:commentItemModel];
        }
        model.commentItemsArray = [tempComments copy];
        // 模拟随机点赞数据
        NSMutableArray *tempLikes = [NSMutableArray new];
        SDTimeLineCellLikeItemModel * model1 = [SDTimeLineCellLikeItemModel new];
        model1.userName = [NSString stringWithFormat:@"%@",formalArray[i][@"praise_number"]];
        model1.userId = @"000";
        
        [tempLikes addObject:model1];
        model.likeItemsArray = [tempLikes copy];
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
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            SDTimeLineCellModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.yxTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [cell setDidClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, SDTimeLineCell * cell) {
            weakSelf.textField.placeholder = [NSString stringWithFormat:@"  回复：%@", commentId];
            weakSelf.currentEditingIndexthPath = cell.indexPath;
            [weakSelf.textField becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentId;
            [weakSelf adjustTableViewToFitKeyboard];
            
        }];
        
        cell.delegate = self;
    }
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    
    cell.starView.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataArray[indexPath.row];
    return [self.yxTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]] + 20;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
    _textField.placeholder = nil;
}
- (CGFloat)cellContentViewWith{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
#pragma mark ========== 评论子文章 ==========
-(void)requestPingLunShaiTu:(NSDictionary *)dic{
    [YX_MANAGER requestessay_comment_childPOST:dic success:^(id object) {
        
    }];
}
#pragma mark ========== 点击跟多评论按钮 ==========
-(void)showMoreComment:(UITableViewCell *)cell{
    _currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[_currentEditingIndexthPath.row];
    NSMutableArray * copyArray = [NSMutableArray arrayWithArray:_pageArray];
    for (NSDictionary * dic in copyArray) {
        if ([dic[@"id"] intValue] == [model.id intValue]) {
            [dic setValue:@([dic[@"page"] intValue]+1) forKey:@"page"];
            [self requestMoreCigar_comment_child:model.id page:kGetString(dic[@"page"])];
        }
    }
}
#pragma mark ========== tableview 点击评论按钮 ==========
- (void)didClickcCommentButtonInCell:(SDTimeLineCell *)cell{
    _currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel * model = self.dataArray[_currentEditingIndexthPath.row];
    self.textField.placeholder = [NSString stringWithFormat:@"  回复：%@",model.name];
    self.currentEditingIndexthPath = cell.indexPath;
    [self.textField becomeFirstResponder];
    self.isReplayingComment = YES;
    self.commentToUser = model.name;
    [self adjustTableViewToFitKeyboard];
}
#pragma mark ========== tableview 点赞按钮 ==========
- (void)didClickLikeButtonInCell:(SDTimeLineCell *)cell{
    kWeakSelf(self);
    NSIndexPath *index = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[index.row];
    [YX_MANAGER requestessay_comment_praisePOST:@{@"comment_id":@([model.id intValue])} success:^(id object) {
        _currentEditingIndexthPath = index;
        _segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
- (IBAction)clickPingLunAction:(id)sender {
    [_textField becomeFirstResponder];
    _textField.placeholder = @"开始评论...";
}






















































#pragma mark ========== 以下为所有自适应和不常用的方法 ==========
- (void)adjustTableViewToFitKeyboard{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.yxTableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.yxTableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.yxTableView setContentOffset:offset animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        
        if (self.isReplayingComment) {
            SDTimeLineCellModel *model = self.dataArray[_currentEditingIndexthPath.row];
            SDTimeLineCellCommentItemModel * itemModel;
            for (SDTimeLineCellCommentItemModel * oldItemModel in model.commentItemsArray) {
                if ([oldItemModel.firstUserName isEqualToString:self.commentToUser]) {
                    itemModel = oldItemModel;
                }
            }
            int farther_id = 0;
            if ([itemModel.firstUserName isEqualToString:self.commentToUser]) {
                farther_id = [itemModel.firstUserId intValue];
            }
            if ([itemModel.secondUserName isEqualToString:self.commentToUser]) {
                farther_id = [itemModel.secondUserId intValue];
            }
            [self requestpost_comment_child:@{@"comment":textField.text,
                                              @"father_id":@([model.id intValue]),
                                              @"aim_id":@(farther_id),
                                              @"aim_name":self.commentToUser
                                              }];
            self.isReplayingComment = NO;
        }else{
            [self pinglunFatherPic:@{@"comment":textField.text,
                                     @"essay_id":@([self.startDic[@"id"] intValue]),
                                     }];
            
        }
        
        /*
         NSMutableArray *temp = [NSMutableArray new];
         [temp addObjectsFromArray:model.commentItemsArray];
         SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
         if (self.isReplayingComment) {
         commentItemModel.firstUserName = @"GSD_iOS";
         commentItemModel.firstUserId = @"GSD_iOS";
         commentItemModel.secondUserName = self.commentToUser;
         commentItemModel.secondUserId = self.commentToUser;
         commentItemModel.commentString = textField.text;
         
         self.isReplayingComment = NO;
         } else {
         commentItemModel.firstUserName = @"GSD_iOS";
         commentItemModel.commentString = textField.text;
         commentItemModel.firstUserId = @"GSD_iOS";
         }
         [temp addObject:commentItemModel];
         model.commentItemsArray = [temp copy];
         
         [self.yxTableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
         */
        _textField.text = @"";
        _textField.placeholder = nil;
        
        return YES;
    }
    return NO;
}
#pragma mark ========== 评论文章 ==========
-(void)pinglunFatherPic:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestPost_essay_commentPOST:dic success:^(id object) {
        _segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}

- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _textField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [_textField resignFirstResponder];
}

- (void)dealloc{
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTextField
{
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    _textField.layer.borderWidth = 1;
    [_textField setFont:[UIFont systemFontOfSize:13]];
    //为textfield添加背景颜色 字体颜色的设置 还有block设置 , 在block中改变它的键盘样式 (当然背景颜色和字体颜色也可以直接在block中写)
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.textColor = [UIColor blackColor];
    _textField.keyboardAppearance = UIKeyboardAppearanceDefault;
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
        [_textField becomeFirstResponder];
    }
    
    /*
     _textField.lee_theme
     .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
     .LeeAddBackgroundColor(NIGHT , [UIColor blackColor])
     .LeeAddTextColor(DAY , [UIColor blackColor])
     .LeeAddTextColor(NIGHT , [UIColor grayColor])
     .LeeAddCustomConfig(DAY , ^(UITextField *item){
     
     item.keyboardAppearance = UIKeyboardAppearanceDefault;
     if ([item isFirstResponder]) {
     [item resignFirstResponder];
     [item becomeFirstResponder];
     }
     }).LeeAddCustomConfig(NIGHT , ^(UITextField *item){
     
     item.keyboardAppearance = UIKeyboardAppearanceDark;
     if ([item isFirstResponder]) {
     [item resignFirstResponder];
     [item becomeFirstResponder];
     }
     });
     */
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width_sd, textFieldH);
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    
    [_textField becomeFirstResponder];
    [_textField resignFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*
     if (!_refreshHeader.superview) {
     
     _refreshHeader = [SDTimeLineRefreshHeader refreshHeaderWithCenter:CGPointMake(40, 45)];
     _refreshHeader.scrollView = self.yxTableView;
     __weak typeof(_refreshHeader) weakHeader = _refreshHeader;
     __weak typeof(self) weakSelf = self;
     [_refreshHeader setRefreshingBlock:^{
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     weakSelf.dataArray = [[weakSelf creatModelsWithCount:10] mutableCopy];
     [weakHeader endRefreshing];
     dispatch_async(dispatch_get_main_queue(), ^{
     [weakself.yxTableView reloadData];
     });
     });
     }];
     [self.yxTableView.superview addSubview:_refreshHeader];
     } else {
     [self.yxTableView.superview bringSubviewToFront:_refreshHeader];
     }
     */
}
-(NSString *)getParamters:(NSString *)type page:(NSString *)page{
    return [NSString stringWithFormat:@"%@/0/%@/%@",type,self.startDic[@"id"],page];
}

@end
