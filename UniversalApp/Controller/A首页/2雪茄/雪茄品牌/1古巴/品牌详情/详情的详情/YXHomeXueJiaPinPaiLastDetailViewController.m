//
//  YXHomeXueJiaPinPaiLastDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/9.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPinPaiLastDetailViewController.h"
#import "YXHomeLastDetailView.h"
#import "YXHomeLastMyTalkView.h"
#import "XHStarRateView.h"
#import "YXMineImageViewController.h"

#import "SDTimeLineTableHeaderView.h"
#import "SDTimeLineRefreshHeader.h"
#import "SDTimeLineRefreshFooter.h"
#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#import "UIView+SDAutoLayout.h"
#import "LEETheme.h"
#import "GlobalDefines.h"
#import "YXHomeSearchMoreViewController.h"

#define kTimeLineTableViewCellId @"SDTimeLineCell"

#define textFieldH 40

@interface YXHomeXueJiaPinPaiLastDetailViewController ()<UITableViewDelegate,UITableViewDataSource,clickMyTalkDelegate,SDTimeLineCellDelegate, UITextFieldDelegate>{
    SDTimeLineRefreshFooter *_refreshFooter;
    SDTimeLineRefreshHeader *_refreshHeader;
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;
    NSInteger _segmentIndex;
    NSMutableArray * _pageArray;//因每个cell都要分页，所以page要根据评论id来分，不能单独写
}
@property(nonatomic,strong)YXHomeLastDetailView * lastDetailView;
@property(nonatomic,strong)YXHomeLastMyTalkView * lastMyTalkView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, copy) NSString *commentToUser;
@property (nonatomic, copy) NSString *commentToUserID;


@end

@implementation YXHomeXueJiaPinPaiLastDetailViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    //初始化所有的控件
    [self initAllControl];


    [self requestPingJunFen];
    [self requestGeRenFen];
    [self requestNewList];
    [self setupTableHeaderView];
}

-(void)initAllControl{
    self.title = self.startDic[@"cigar_name"];
    _segmentIndex = 0;
    _dataArray = [[NSMutableArray alloc]init];
    _pageArray = [[NSMutableArray alloc]init];
    self.yxTableView.tableFooterView = [[UIView alloc]init];
    [self.yxTableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    self.yxTableView.estimatedRowHeight = 0;
    self.yxTableView.estimatedSectionHeaderHeight = 0;
    self.yxTableView.estimatedSectionFooterHeight = 0;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeTop;
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark - 设置tableHeaderView
- (void)setupTableHeaderView{
    CGFloat height = 0.0;
    CGFloat tagHeight = 0;
    if (self.imageArray.count == 0) {
        height = 0;
        tagHeight = 0;
    }
    if (self.imageArray.count >0 && self.imageArray.count <=3) {
        height = 100;
        tagHeight = 40;
    }
    if (self.imageArray.count > 4) {
        height = 200;
        tagHeight = 40;
    }
    
    
    kWeakSelf(self);
    //添加分隔线颜色设置
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXHomeLastDetailView" owner:self options:nil];
    self.lastDetailView = [nib objectAtIndex:0];
    self.lastDetailView.delegate = self;
    //点击segment
    self.lastDetailView.block = ^(NSInteger index) {
        index == 0 ? [weakself requestNewList] : [weakself requestHotList];
        _segmentIndex = index;
    };
    [self.lastDetailView againSetDetailView:weakself.startDic];
    [self.lastDetailView setSixPhotoView:self.imageArray];
    
    self.lastDetailView.searchAllBlock = ^{
        YXHomeSearchMoreViewController * VC = [[YXHomeSearchMoreViewController alloc]init];
        VC.tag = weakself.startDic[@"cigar_name"];
        VC.scrollIndex = 0;
        [weakself.navigationController pushViewController:VC animated:YES];
    };
    self.lastDetailView.fixBlock = ^(NSInteger index) {
        YXHomeSearchMoreViewController * VC = [[YXHomeSearchMoreViewController alloc]init];
        VC.tag = weakself.startDic[@"cigar_name"];
        VC.scrollIndex = index;
        [weakself.navigationController pushViewController:VC animated:YES];
    };
    

    //listview
    CGFloat listHeight = 0;
    NSMutableArray * listData = [NSMutableArray array];
    if (self.startDic[@"argument"]) {
        NSDictionary * dic = [self dictionaryWithJsonString:kGetString(self.startDic[@"argument"])];
        for (NSString * key in dic) {
            NSString * listKey = [key UnicodeToUtf8];
            NSString * listValue = [[dic objectForKey:key] UnicodeToUtf8];
            [listData addObject:@{listKey:listValue}];
        }
        listHeight  = listData.count * 40 ;
    }
    
    
    // 设置 view 的 frame(将设置 frame 提到设置 tableHeaderView 之前)
    self.lastDetailView.frame = CGRectMake(0, 0, kScreenWidth, (AxcAE_IsiPhoneX ? 410 : 500) + height + tagHeight + listHeight);
    // 设置 tableHeaderView
    self.yxTableView.tableHeaderView = self.lastDetailView;
    
}
/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    kWeakSelf(self);
    //添加分隔线颜色设置
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXHomeLastDetailView" owner:self options:nil];
    self.lastDetailView = [nib objectAtIndex:0];
    self.lastDetailView.frame = CGRectMake(0, 0, KScreenWidth, 1000);
    self.lastDetailView.delegate = self;
    //点击segment
    self.lastDetailView.block = ^(NSInteger index) {
        index == 0 ? [weakself requestNewList] : [weakself requestHotList];
        _segmentIndex = index;
    };
    [self.lastDetailView againSetDetailView:weakself.startDic];
    
    [self.lastDetailView setSixPhotoView:self.imageArray];

    
    self.lastDetailView.searchAllBlock = ^{
        //        UIStoryboard * stroryBoard = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
        //        YXMineImageViewController * imageVC = [[YXMineImageViewController alloc]init];
        //        [weakself.navigationController pushViewController:imageVC animated:YES];
    };
    return self.lastDetailView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    if (self.imageArray.count == 0) {
        height = 0;
    }
    if (self.imageArray.count >0 && self.imageArray.count <=3) {
        height = 100;
    }
    if (self.imageArray.count > 4) {
        height = 200;
    }
    return 750 + height;
}
 */
-(void)requestNewList{
    kWeakSelf(self);
    //请求评价列表 最新评论列表
    [YX_MANAGER requestCigar_commentGET:[self getParamters:@"3"] success:^(id object) {
        weakself.dataArray = [NSMutableArray arrayWithArray:[weakself creatModelsWithCount:object]];
        [weakself refreshTableView];
    }];
}
-(void)requestHotList{
    kWeakSelf(self);
    //请求评价列表 最热评论列表
    [YX_MANAGER requestCigar_commentGET:[self getParamters:@"4"] success:^(id object) {
        weakself.dataArray = [NSMutableArray arrayWithArray:[weakself creatModelsWithCount:object]];
        [weakself refreshTableView];
    }];
}
-(void)refreshTableView{
//    if (self.currentEditingIndexthPath) {
//        [self.yxTableView reloadRowsAtIndexPaths:@[self.currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
//    }else{
        [self.yxTableView reloadData];
//    }
}
-(void)requestPingJunFen{
    kWeakSelf(self);
    //请求评价列表 平均分
    [YX_MANAGER requestCigar_commentGET:[self getParamters:@"1"] success:^(id object) {
        [weakself.lastDetailView fiveStarViewUIAllDataDic_PingJunFen:object];
    }];
}
-(void)requestGeRenFen{
    kWeakSelf(self);
    //请求评价列表 个人分
    [YX_MANAGER requestCigar_commentGET:[self getParamters:@"2"] success:^(id object) {
        [weakself.lastDetailView fiveStarViewUIAllDataDic_GeRenFen:object];
    }];
}

-(void)requestCigar_comment_child:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestCigar_comment_childPOST:dic success:^(id object) {
        _segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
-(void)requestMoreCigar_comment_child:(NSString *)farther_id page:(NSString *)page{
    kWeakSelf(self);
    NSString * string = [NSString stringWithFormat:@"%@/%@",page,farther_id];
    [YX_MANAGER requestCigar_comment_childGET:string success:^(id object) {
        
        if ([object count] == 0) {
             [QMUITips showInfo:@"没有更多评论了" detailText:@"" inView:weakself.yxTableView hideAfterDelay:1];
            return ;
        }
        
        SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
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
                commentItemModel.commentString = [kGetString(dic[@"comment"]) UnicodeToUtf8];
                commentItemModel.labelTag = [dic[@"id"] integerValue];

                self.isReplayingComment = YES;
            } else {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName =kGetString(dic[@"user_name"]);
                commentItemModel.commentString = [kGetString(dic[@"comment"]) UnicodeToUtf8];
                commentItemModel.labelTag = [dic[@"id"] integerValue];
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
        [self.yxTableView reloadRowsAtIndexPaths:@[self.currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupTextField];
}


#pragma mark ========== 点击我来评论 ==========
-(void)clickMyTalkAction{
    
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXHomeLastMyTalkView" owner:self options:nil];
    self.lastMyTalkView = [nib objectAtIndex:0];
    self.lastMyTalkView.frame = CGRectMake(0, 0,KScreenWidth, 340-75);
    self.lastMyTalkView.backgroundColor = UIColorWhite;
    self.lastMyTalkView.layer.masksToBounds = YES;
    self.lastMyTalkView.layer.cornerRadius = 6;
    self.lastMyTalkView.parDic = [[NSMutableDictionary alloc]init];
    kWeakSelf(self);
    self.lastMyTalkView.block = ^{
        _segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    };
    self.lastMyTalkView.selectBlock = ^(NSString * str) {
        
    };
    [self.lastMyTalkView.parDic setValue:@([self.startDic[@"id"] intValue]) forKey:@"cigar_id"];
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    modalViewController.contentView = self.lastMyTalkView;
    [modalViewController showWithAnimated:YES completion:nil];
}
#pragma mark ========== 点击全部图片 ==========

#pragma mark ========== tableview数据 ==========
- (NSArray *)creatModelsWithCount:(NSArray *)formalArray{
    [_pageArray removeAllObjects];

    NSMutableArray *resArr = [NSMutableArray new];
    for (int i = 0; i < formalArray.count; i++) {
        SDTimeLineCellModel *model = [SDTimeLineCellModel new];
        NSMutableDictionary * pageDic = [[NSMutableDictionary alloc]init];
        model.iconName = formalArray[i][@"user_photo"];
        model.name = formalArray[i][@"user_name"];
        model.userID = formalArray[i][@"user_id"];

        model.msgContent = [formalArray[i][@"comment"] UnicodeToUtf8];
        model.commontTime = [formalArray[i][@"update_time"] integerValue];
        model.score = [formalArray[i][@"recommend"] integerValue] == 1 ? @"(推荐)" :
                      [formalArray[i][@"recommend"] integerValue] == 2 ? @"(中立)" : @"(不推荐)";  //[formalArray[i][@"average_score"] floatValue];
        model.praise = kGetString(formalArray[i][@"praise"]);
        model.praise_num = kGetString(formalArray[i][@"praise_number"]);
        model.id =  kGetString(formalArray[i][@"id"]);
        
        [pageDic setValue:@([model.id intValue]) forKey:@"id"];
        [pageDic setValue:@(0) forKey:@"page"];
  
        
        if ([formalArray[i][@"child_list"] count] == 0) {
            model.moreCountPL = @"0";
        }else{
            NSArray * array = formalArray[i][@"child_list"];
            model.moreCountPL = [NSString stringWithFormat:@"%ld",[formalArray[i][@"child_number"] integerValue] - [array count]];
        }
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
            commentItemModel.commentString = [child_listArray[i][@"comment"] UnicodeToUtf8];
            commentItemModel.labelTag = [child_listArray[i][@"id"] integerValue];

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
        /*
         // 模拟随机点赞数据
         int likeRandom = arc4random_uniform(3);
         NSMutableArray *tempLikes = [NSMutableArray new];
         for (int i = 0; i < likeRandom; i++) {
         SDTimeLineCellLikeItemModel *model = [SDTimeLineCellLikeItemModel new];
         int index = arc4random_uniform((int)namesArray.count);
         model.userName = namesArray[index];
         model.userId = namesArray[index];
         [tempLikes addObject:model];
         }
         
         model.likeItemsArray = [tempLikes copy];
         */
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
    cell.model = self.dataArray[indexPath.row];

    CGFloat height1 = cell.model.moreCountPL.integerValue <= 0 ? 0 : 20;
    [cell.showMoreCommentBtn setTitle:height1 == 0 ? @"" : @"显示更多回复 >>"  forState:UIControlStateNormal];
    cell.showMoreCommentBtn.hidden = height1 == 0;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            SDTimeLineCellModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.yxTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        /*
        [cell setDidClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, SDTimeLineCell * cell) {
            weakSelf.textField.placeholder = [NSString stringWithFormat:@"  回复：%@", commentId];
            weakSelf.currentEditingIndexthPath = cell.indexPath;
            [weakSelf.textField becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentId;
            
            [weakSelf adjustTableViewToFitKeyboard];
            
        }];
        */
        [cell setDidLongClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, SDTimeLineCell *cell,NSInteger tag) {
            //在此添加你想要完成的功能
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {}];
            QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                
                kWeakSelf(self);
                [YX_MANAGER requestDelCigarPl_WenDa:NSIntegerToNSString(tag) success:^(id object) {
                    [QMUITips showSucceed:@"删除成功"];
                    _segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
                }];
                
                
            }];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleActionSheet];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController showWithAnimated:YES];
        }];
        cell.delegate = self;
    }
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    
    
    
    SDTimeLineCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    self.currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel * model = self.dataArray[self.currentEditingIndexthPath.row];
    self.textField.placeholder = [NSString stringWithFormat:@"  回复：%@",model.name];
    self.currentEditingIndexthPath = cell.indexPath;
    [self.textField becomeFirstResponder];
    self.isReplayingComment = YES;
    self.commentToUser = model.name;
    self.commentToUserID = model.userID;
    [self adjustTableViewToFitKeyboard];
    
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
#pragma mark ========== 点击跟多评论按钮 ==========
-(void)showMoreComment:(UITableViewCell *)cell{
    self.currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
    NSMutableArray * copyArray = [NSMutableArray arrayWithArray:_pageArray];
    for (NSDictionary * dic in copyArray) {
        if ([dic[@"id"] intValue] == [model.id intValue]) {
            [dic setValue:@([dic[@"page"] intValue]+1) forKey:@"page"];
            
            kWeakSelf(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself requestMoreCigar_comment_child:model.id page:kGetString(dic[@"page"])];
            });
        }
    }
}
#pragma mark ========== tableview 点击评论按钮 ==========
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell{
    [_textField becomeFirstResponder];
    self.currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
    self.commentToUser = model.name;
    self.commentToUserID = model.userID;
    [self adjustTableViewToFitKeyboard];
}
#pragma mark ========== tableview 点赞按钮 ==========
- (void)didClickLikeButtonInCell:(SDTimeLineCell *)cell{
    kWeakSelf(self);
    NSIndexPath *index = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[index.row];
    [YX_MANAGER requestPraise_cigaPr_commentPOST:@{@"comment_id":@([model.id intValue])} success:^(id object) {
        self.currentEditingIndexthPath = index;
        _segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
    /*
     if (!model.isLiked) {
     SDTimeLineCellLikeItemModel *likeModel = [SDTimeLineCellLikeItemModel new];
     likeModel.userName = @"GSD_iOS";
     likeModel.userId = @"gsdios";
     [temp addObject:likeModel];
     model.liked = YES;
     } else {
     SDTimeLineCellLikeItemModel *tempLikeModel = nil;
     for (SDTimeLineCellLikeItemModel *likeModel in model.likeItemsArray) {
     if ([likeModel.userId isEqualToString:@"gsdios"]) {
     tempLikeModel = likeModel;
     break;
     }
     }
     [temp removeObject:tempLikeModel];
     model.liked = NO;
     }
     model.likeItemsArray = [temp copy];
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [self.yxTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    });
}






















































#pragma mark ========== 以下为所有自适应和不常用的方法 ==========
- (void)adjustTableViewToFitKeyboard{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.yxTableView cellForRowAtIndexPath:self.currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
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
        SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
        [self requestCigar_comment_child:@{@"comment":[textField.text utf8ToUnicode],
                                               @"father_id":@([model.id intValue]),
                                               @"aim_id":self.commentToUserID,
                                               @"aim_name":self.commentToUser
                                               }];
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

        [self.yxTableView reloadRowsAtIndexPaths:@[self.currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
  */
        _textField.text = @"";
        _textField.placeholder = nil;
        
        return YES;
    }
    return NO;
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
    [_textField removeFromSuperview];

}

- (void)dealloc
{
    [_refreshHeader removeFromSuperview];
    [_refreshFooter removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setupTextField{
    [_textField removeFromSuperview];
    _textField = [[UITextField alloc]init];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.placeholder = @" 开始评论...";
    _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    _textField.layer.borderWidth = 1;
    [_textField setFont:[UIFont systemFontOfSize:14]];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.textColor = [UIColor blackColor];
    _textField.tag = 8899;
    _textField.frame = CGRectMake(10, KScreenHeight, KScreenWidth-20, 30);
    
           ViewBorderRadius(_textField, 10, 1, YXRGBAColor(238, 238, 238));

    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(20,0,7,26)];
    leftView.backgroundColor = [UIColor clearColor];
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
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
-(NSString *)getParamters:(NSString *)type{
    return [NSString stringWithFormat:@"%@/%@/%@",type,self.startDic[@"id"],@"1"];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{};
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
