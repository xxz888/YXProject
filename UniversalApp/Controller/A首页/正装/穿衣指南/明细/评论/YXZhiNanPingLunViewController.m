//
//  YXZhiNanPingLunViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/11.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXZhiNanPingLunViewController.h"
#import "ZInputToolbar.h"
#import "UIView+LSExtension.h"

@interface YXZhiNanPingLunViewController ()<ZInputToolbarDelegate,QMUIMoreOperationControllerDelegate>{
    BOOL zanBool;
}
@end

@implementation YXZhiNanPingLunViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
     return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];

    //初始化所有的控件
    [self initAllControl];
    [self requestNewList];
    self.title = @"评论";
}
-(void)headerRereshing{
    [super headerRereshing];
     [self requestNewList];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestNewList];
}
-(void)initAllControl{
    [super initAllControl];
}
#pragma mark ========== 获取晒图评论列表 ==========
-(void)requestNewList{
    kWeakSelf(self);
    //请求评价列表 最新评论列表
    NSString * par = [NSString stringWithFormat:@"obj=1&target_id=%@&page=%@",self.startId,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestPubSearchAndDelComment:par success:^(id object) {
        if ([object count] > 0) {
            weakself.dataArray = [weakself commonAction:[weakself creatModelsWithCount:object] dataArray:weakself.dataArray];
        }else{
            [weakself.yxTableView.mj_header endRefreshing];
            [weakself.yxTableView.mj_footer endRefreshing];
        }
        [weakself refreshTableView];
        
    }];
}
-(void)refreshTableView{
    [self.yxTableView reloadData];
}
#pragma mark ========== 评论子评论 ==========
-(void)requestpost_comment_child:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestPubFaBuChildPingLunComment:dic success:^(id object) {
        [weakself requestNewList];
    }];
}
#pragma mark ========== 更多评论 ==========
-(void)requestMoreCigar_comment_child:(NSString *)farther_id page:(NSString *)page{
    kWeakSelf(self);
    NSString * string = [NSString stringWithFormat:@"father_id=%@&page=%@",farther_id,page];
    [YX_MANAGER requestPubSearchChildPingLunListComment:string success:^(id object) {
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
                commentItemModel.firstUserName = kGetString(dic[@"user_info"][@"name"]);
                commentItemModel.secondUserId = kGetString(dic[@"aim_id"]);
                commentItemModel.secondUserName = kGetString(dic[@"aim_info"][@"name"]);
                commentItemModel.commentString = [kGetString(dic[@"comment"]) UnicodeToUtf8];
                commentItemModel.labelTag = [dic[@"id"] integerValue];
            } else {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName =kGetString(dic[@"user_info"][@"name"]);
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
        [weakself.yxTableView reloadData];
    }];
}
#pragma mark ========== tableview数据 ==========
- (NSArray *)creatModelsWithCount:(NSArray *)formalArray{
    [self.pageArray removeAllObjects];
    NSMutableArray *resArr = [NSMutableArray new];
    for (int i = 0; i < formalArray.count; i++) {
        SDTimeLineCellModel *model = [SDTimeLineCellModel new];
        NSMutableDictionary * pageDic = [[NSMutableDictionary alloc]init];
        model.iconName = formalArray[i][@"photo"];
        model.name = formalArray[i][@"user_name"];
        model.userID = formalArray[i][@"user_id"];
        
        model.msgContent = [formalArray[i][@"comment"] UnicodeToUtf8] ;
        model.commontTime = [formalArray[i][@"publish_time"] integerValue];
        model.praise = kGetString(formalArray[i][@"is_praise"]);
        model.praise_num = kGetString(formalArray[i][@"praise_number"]);
        
        
        model.id =  kGetString(formalArray[i][@"id"]);
        model.postid = kGetString(formalArray[i][@"postid"]);
        if ([formalArray[i][@"child_list"] count] == 0) {
            model.moreCountPL = @"0";
        }else{
            model.moreCountPL = [NSString stringWithFormat:@"%ld",[formalArray[i][@"child_number"] integerValue] - [formalArray[i][@"child_list"] count]];
        }
        
        [pageDic setValue:@([model.id intValue]) forKey:@"id"];
        [pageDic setValue:@(0) forKey:@"page"];
        [self.pageArray addObject:pageDic];
        // 模拟随机评论数据
        NSMutableArray *tempComments = [NSMutableArray new];
        NSArray * child_listArray =  [NSArray arrayWithArray:formalArray[i][@"child_list"]];
        for (int i = 0; i < [child_listArray count]; i++) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            commentItemModel.firstUserName = kGetString(child_listArray[i][@"user_info"][@"name"]);
            commentItemModel.firstUserId = kGetString(child_listArray[i][@"user_id"]);
            if (child_listArray[i][@"aim_id"] != 0) {
                commentItemModel.secondUserName = kGetString(child_listArray[i][@"aim_info"][@"name"]);
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
        [resArr addObject:model];
    }
    return [resArr copy];
}
#pragma mark ========== 点击跟多评论按钮 ==========
-(void)showMoreComment:(UITableViewCell *)cell{
    self.currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
    NSMutableArray * copyArray = [NSMutableArray arrayWithArray:self.pageArray];
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
- (void)didClickcCommentButtonInCell:(SDTimeLineCell *)cell{
    
    
    [self setupTextField];
    
    self.currentEditingIndexthPath = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel * model = self.dataArray[self.currentEditingIndexthPath.row];
    self.textField.placeholder = [NSString stringWithFormat:@"  回复：%@",model.name];
    self.currentEditingIndexthPath = cell.indexPath;
    self.isReplayingComment = YES;
    self.commentToUser = model.name;
    self.commentToUserID = model.userID;
    [self adjustTableViewToFitKeyboard];
}
#pragma mark ========== tableview 点赞按钮 ==========
- (void)didClickLikeButtonInCell:(SDTimeLineCell *)cell{
    kWeakSelf(self);
    NSIndexPath *index = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[index.row];
    [YX_MANAGER requestPubDianZanComment:model.id success:^(id object) {
        weakself.currentEditingIndexthPath = index;
        [weakself requestNewList];
    }];
}
#pragma mark ========== 评论 ==========
-(void)pinglunFatherPic:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestPubFaBuPingLunComment:dic success:^(id object) {
        [weakself requestNewList];
    }];
}

-(void)delePingLun:(NSInteger)tag{
    kWeakSelf(self);
    [YX_MANAGER requestPubSearchAndDelChildComment:NSIntegerToNSString(tag) success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        [weakself requestNewList];
    }];
}
-(void)deleFather_PingLun:(NSString *)tag{
    kWeakSelf(self);
    NSString * str = [NSString stringWithFormat:@"target_id=%@",tag];
    [YX_MANAGER requestPubSearchAndDelComment:str success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        [weakself requestNewList];
    }];
}

- (IBAction)clickPingLunAction:(id)sender{
    [self setupTextField];
    [self.inputToolbar.textInput becomeFirstResponder];
}

- (void)setupTextField{
    [self.inputToolbar removeFromSuperview];
    self.inputToolbar = [[ZInputToolbar alloc] initWithFrame:CGRectMake(0,self.view.height, self.view.width, 60)];
    self.inputToolbar.textViewMaxLine = 5;
    self.inputToolbar.delegate = self;
    self.inputToolbar.placeholderLabel.text = @"开始评论...";
    [self.view addSubview:self.inputToolbar];
}
#pragma mark - ZInputToolbarDelegate
-(void)inputToolbar:(ZInputToolbar *)inputToolbar sendContent:(NSString *)sendContent {
    [self finishTextView:inputToolbar.textInput];
    // 清空输入框文字
    [self.inputToolbar sendSuccessEndEditing];
}
#pragma mark - UITextFieldDelegate
-(void)finishTextView:(UITextView *)textField{
    if (self.isReplayingComment) {
        SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
        [self requestpost_comment_child:@{@"comment":[textField.text utf8ToUnicode],
                                          @"father_id":@([model.id intValue]),
                                          @"aim_id":self.commentToUserID,
                                          }];
        self.isReplayingComment = NO;
    }else{
        [self pinglunFatherPic:@{@"comment":[textField.text utf8ToUnicode],
                                 @"target_id":self.startId,
                                 @"obj":@"1"
                                 }];
        
    }
}

@end
