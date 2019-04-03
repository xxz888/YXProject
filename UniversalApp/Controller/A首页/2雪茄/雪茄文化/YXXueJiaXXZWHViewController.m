//
//  YXXueJiaXXZWHViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/3/27.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXXueJiaXXZWHViewController.h"

@interface YXXueJiaXXZWHViewController ()<UIWebViewDelegate>{
    CGFloat imageHeight;
    CGFloat tagHeight;

}
@property (nonatomic,strong) UIWebView *xxzWebView;

@end

@implementation YXXueJiaXXZWHViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
     return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];

    //初始化所有的控件
    [self initAllControl];
    [self addRefreshView:self.yxTableView];
    [self requestNewList];
    
}
- (void)keyboardNotification:(NSNotification *)notification{
    CGPoint offset = CGPointMake(0, 0);
   // [self.yxTableView setContentOffset:offset animated:YES];
    
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.textField.frame = textFieldRect;
    }];
    CGFloat h = rect.size.height + textFieldH;
    if (self.totalKeybordHeight != h) {
        self.totalKeybordHeight = h;
        //[self adjustTableViewToFitKeyboard];
    }
}
-(UIView *)xxzWebView{
    if (!_xxzWebView) {
        _xxzWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
        _xxzWebView.delegate = self;
        //获取bundlePath 路径
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        //获取本地html目录 basePath
        NSString *basePath = [NSString stringWithFormat:@"%@/%@",bundlePath,@"html"];
        //获取本地html目录 baseUrl
        NSURL *baseUrl = [NSURL fileURLWithPath: basePath isDirectory: YES];
        //显示内容
        [_xxzWebView loadHTMLString:[ShareManager adaptWebViewForHtml:_webDic[@"essay"]] baseURL: baseUrl];
        
   
    }
    return _xxzWebView;
}
- (void)webViewDidFinishLoad:(UIWebView *)wb{
    tagHeight = [[wb stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    _xxzWebView.frame = CGRectMake(0, 0, KScreenWidth, tagHeight + 30);

    
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = YXRGBAColor(239, 239, 239);
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(0, tagHeight, KScreenWidth, 30);
    label.text = @" 精彩评论";
    [_xxzWebView addSubview:label];
    
    [self.yxTableView reloadData];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.xxzWebView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  tagHeight == 0 ? 1 : tagHeight + 30;
}
-(void)headerRereshing{
    [super headerRereshing];
    self.segmentIndex == 0 ? [self requestNewList] : [self requestHotList];
}
-(void)footerRereshing{
    [super footerRereshing];
    self.segmentIndex == 0 ? [self requestNewList] : [self requestHotList];
}
-(void)initAllControl{
    [super initAllControl];
    kWeakSelf(self);
    //点击segment
    self.lastDetailView.block = ^(NSInteger index) {
        index == 0 ? [weakself requestNewList] : [weakself requestHotList];
        weakself.segmentIndex = index;
    };
    [self setupTextField];
}
#pragma mark ========== 获取晒图评论列表 ==========
-(void)requestNewList{

    kWeakSelf(self);
    //请求评价列表 最新评论列表
    NSString * par = [NSString stringWithFormat:@"%@/%@/",_webDic[@"id"],NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGetCigar_culture_comment:par success:^(id object) {
        if ([object count] > 0) {
            weakself.dataArray = [weakself commonAction:[weakself creatModelsWithCount:object] dataArray:weakself.dataArray];
            [weakself refreshTableView];
        }else{
            [weakself.yxTableView.mj_header endRefreshing];
            [weakself.yxTableView.mj_footer endRefreshing];
        }
    }];
}
-(void)requestHotList{
}
-(void)refreshTableView{
    [self.yxTableView reloadData];
}
#pragma mark ========== 评论子评论 ==========
-(void)requestpost_comment_child:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestFaBuCigar_culture_comment_child:dic success:^(id object) {
        self.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
#pragma mark ========== 更多评论 ==========
-(void)requestMoreCigar_comment_child:(NSString *)farther_id page:(NSString *)page{
    kWeakSelf(self);
    NSString * string = [NSString stringWithFormat:@"%@/%@",farther_id,page];
    [YX_MANAGER requestGetCigar_culture_comment_child:string success:^(id object) {
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
                
                //                self.isReplayingComment = YES;
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
        model.commontTime = [formalArray[i][@"update_time"] integerValue];
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
        [resArr addObject:model];
    }
    return [resArr copy];
}
#pragma mark ========== 点击跟多评论按钮 ==========
-(void)showMoreComment:(UITableViewCell *)cell{
    
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }

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
    
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }

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
#pragma mark ========== tableview 点赞按钮 ==========
- (void)didClickLikeButtonInCell:(SDTimeLineCell *)cell{
    
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }

    kWeakSelf(self);
    NSIndexPath *index = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[index.row];
    [YX_MANAGER requestDianZanCigar_culture_comment_praise:kGetString(model.id) success:^(id object) {
        self.currentEditingIndexthPath = index;
        self.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length) {
        [self.textField resignFirstResponder];
        if (self.isReplayingComment) {
            SDTimeLineCellModel *model = self.dataArray[self.currentEditingIndexthPath.row];
            [self requestpost_comment_child:@{@"comment":[textField.text utf8ToUnicode],
                                              @"father_id":@([model.id intValue]),
                                              @"aim_id":self.commentToUserID,
                                              @"aim_name":self.commentToUser
                                              }];
            self.isReplayingComment = NO;
        }else{
            [self pinglunFatherPic:@{@"comment":[textField.text utf8ToUnicode],
                                     @"cigar_culture_id":@([self.webDic[@"id"] intValue]),
                                     }];
            
        }
        self.textField.text = @"";
        self.textField.placeholder = nil;
        
        return YES;
    }
    return NO;
}
#pragma mark ========== 评论 ==========
-(void)pinglunFatherPic:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestPostCigar_culture_comment:dic success:^(id object) {
        self.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
-(NSString *)getParamters:(NSString *)type page:(NSString *)page{
    return [NSString stringWithFormat:@"%@/0/%@/%@",type,self.webDic[@"id"],page];
}
-(void)delePingLun:(NSInteger)tag{
    kWeakSelf(self);
    [YX_MANAGER requestDelGetCigar_culture_comment_child:NSIntegerToNSString(tag) success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        weakself.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}

@end
