//
//  YXMineFootDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/29.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineFootDetailViewController.h"
#import "XHWebImageAutoSize.h"





@interface YXMineFootDetailViewController ()<SDCycleScrollViewDelegate>{
    CGFloat imageHeight;
}

@end
@implementation YXMineFootDetailViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
     return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    if ([self.startDic[@"pic1"] length] >= 5) {
        NSString * str1 = [(NSMutableString *)self.startDic[@"pic1"] replaceAll:@" " target:@"%20"];

        imageHeight   = [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:str1] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:400];
    }
    //初始化所有的控件
    [self initAllControl];
    [self addRefreshView:self.yxTableView];
    [self requestNewList];
}
-(void)initAllControl{
    kWeakSelf(self);
    [super initAllControl];
    //点击segment
    self.lastDetailView.block = ^(NSInteger index) {
        index == 0 ? [weakself requestNewList] : [weakself requestHotList];
        weakself.segmentIndex = index;
    };
    [self setupTextField];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.lastDetailView) {
        //添加分隔线颜色设置
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXMineImageDetailHeaderView" owner:self options:nil];
        self.lastDetailView = [nib objectAtIndex:0];
    }
    [self.imageArr removeAllObjects];
    if ([self.startDic[@"pic1"] length] >= 5) {
        [self.imageArr addObject:self.startDic[@"pic1"]];
    }
    if ([self.startDic[@"pic2"] length] >= 5) {
        [self.imageArr addObject:self.startDic[@"pic2"]];
    }
    if ([self.startDic[@"pic3"] length] >= 5) {
        [self.imageArr addObject:self.startDic[@"pic3"]];
    }
    [self.lastDetailView setUpSycleScrollView:self.imageArr height:imageHeight];
    self.lastDetailView.rightCountLbl.text = [NSString stringWithFormat:@"%@/%ld",@"1",self.imageArr.count];
    self.lastDetailView.rightCountLbl.hidden = [self.lastDetailView.rightCountLbl.text isEqualToString:@"1/1"] ||
    [self.lastDetailView.rightCountLbl.text isEqualToString:@"1/0"];
    self.lastDetailView.titleLbl.text = self.startDic[@"user_name"];
    NSString * str1 = [(NSMutableString *)self.startDic[@"user_photo"] replaceAll:@" " target:@"%20"];
    [self.lastDetailView.titleImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.lastDetailView.titleImageView.layer.masksToBounds = YES;
    self.lastDetailView.titleImageView.layer.cornerRadius = self.lastDetailView.titleImageView.frame.size.width / 2.0;
    self.lastDetailView.titleTimeLbl.text = [ShareManager timestampSwitchTime:[self.startDic[@"publish_time"] longLongValue] andFormatter:@""];
    self.lastDetailView.userInteractionEnabled = YES;
    
    
    
    
    self.lastDetailView.contentLbl.text =  [[NSString stringWithFormat:@"%@%@",self.startDic[@"content"] ? self.startDic[@"content"]:self.startDic[@"describe"],self.startDic[@"index"]] UnicodeToUtf8];
    self.lastDetailView.userInteractionEnabled = YES;
    self.lastDetailView.contentHeight.constant = [self getLblHeight:self.startDic];
    [ShareManager setLineSpace:9 withText:self.lastDetailView.contentLbl.text inLabel:self.lastDetailView.contentLbl tag:self.startDic[@"index"]];
    return  self.lastDetailView;
}
-(CGFloat)getLblHeight:(NSDictionary *)dic{
    NSString * titleText = [NSString stringWithFormat:@"%@%@",dic[@"content"] ? dic[@"content"]:dic[@"describe"],dic[@"index"]];
    CGFloat height_size = [ShareManager inTextOutHeight:[titleText UnicodeToUtf8] lineSpace:9 fontSize:14];
    return height_size;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  120 + imageHeight + [self getLblHeight:self.startDic];
}
-(void)headerRereshing{
    [super headerRereshing];
    self.segmentIndex == 0 ? [self requestNewList] : [self requestHotList];
}
-(void)footerRereshing{
    [super footerRereshing];
    self.segmentIndex == 0 ? [self requestNewList] : [self requestHotList];
}
#pragma mark ========== 获取足迹评论列表 ==========
-(void)requestNewList{
    kWeakSelf(self);
    //请求评价列表 最新评论列表
    [YX_MANAGER requestGetNewFootList:[self getParamters:@"1" page:NSIntegerToNSString(self.requestPage)] success:^(id object) {
        
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
    kWeakSelf(self);
    //请求评价列表 最热评论列表
    [YX_MANAGER requestGetHotFootList:[self getParamters:@"2" page:NSIntegerToNSString(self.requestPage)] success:^(id object) {
        if ([object count] > 0) {
           weakself.dataArray = [weakself commonAction:[weakself creatModelsWithCount:object] dataArray:weakself.dataArray]; 
            [weakself refreshTableView];
        }else{
            [weakself.yxTableView.mj_header endRefreshing];
            [weakself.yxTableView.mj_footer endRefreshing];
            
        }
    }];
}
-(void)refreshTableView{
//    if (self.currentEditingIndexthPath) {
//        [self.yxTableView reloadRowsAtIndexPaths:@[self.currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
//    }else{
        [self.yxTableView reloadData];
//    }
}
#pragma mark ========== 评论子评论 ==========
-(void)requestpost_comment_child:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestFaBuFoot_child_PingLun:dic success:^(id object) {
        self.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
#pragma mark ========== 更多评论 ==========
-(void)requestMoreCigar_comment_child:(NSString *)farther_id page:(NSString *)page{
    kWeakSelf(self);
    NSString * string = [NSString stringWithFormat:@"%@/%@",farther_id,page];
    [YX_MANAGER requestGetFootPingLun_Child_List:string success:^(id object) {
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

//
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
        model.msgContent = [formalArray[i][@"comment"] UnicodeToUtf8];
        model.commontTime = [formalArray[i][@"update_time"] integerValue];
        model.praise = kGetString(formalArray[i][@"is_praise"]);
        model.praise_num = kGetString(formalArray[i][@"praise_number"]);
        model.id =  kGetString(formalArray[i][@"id"]);
        model.postid = kGetString(formalArray[i][@"track_id"]);
        [pageDic setValue:@([model.id intValue]) forKey:@"id"];
        [pageDic setValue:@(0) forKey:@"page"];
        [self.pageArray addObject:pageDic];
        if ([formalArray[i][@"child_list"] count] == 0) {
            model.moreCountPL = @"0";
        }else{
            model.moreCountPL = [NSString stringWithFormat:@"%ld",[formalArray[i][@"child_number"] integerValue] - [formalArray[i][@"child_list"] count]];
        }
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
            commentItemModel.labelTag = [child_listArray[i][@"id"] integerValue];
            commentItemModel.commentString = [child_listArray[i][@"comment"] UnicodeToUtf8];
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
            [self requestMoreCigar_comment_child:model.id page:kGetString(dic[@"page"])];
        }
    }
}
#pragma mark ========== tableview 点击评论按钮 ==========
- (void)didClickcCommentButtonInCell:(SDTimeLineCell *)cell{
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
    kWeakSelf(self);
    NSIndexPath *index = [self.yxTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[index.row];
    [YX_MANAGER requestDianZanFoot_PingLun:@{@"comment_id":@([model.id intValue])} success:^(id object) {
        self.currentEditingIndexthPath = index;
        self.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
- (IBAction)clickPingLunAction:(id)sender {
    [self.textField becomeFirstResponder];
    self.textField.placeholder = @" 开始评论...";;
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
                                              }];
            self.isReplayingComment = NO;
        }else{
            [self pinglunFatherPic:@{@"comment":[textField.text utf8ToUnicode],
                                     @"track_id":@([self.startDic[@"id"] intValue]),
                                     }];
            
        }
        self.textField.text = @"";
        self.textField.placeholder = nil;
        
        return YES;
    }
    return NO;
}
#pragma mark ========== 评论足迹 ==========
-(void)pinglunFatherPic:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestPingLunFoot:dic success:^(id object) {
        self.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}

-(NSString *)getParamters:(NSString *)type page:(NSString *)page{
    return [NSString stringWithFormat:@"%@/%@",self.startDic[@"id"],page];
}
-(void)delePingLun:(NSInteger)tag{
    kWeakSelf(self);
    [YX_MANAGER requestDelChildPl_Zuji:NSIntegerToNSString(tag) success:^(id object) {
        [QMUITips showSucceed:@"删除成功"];
        weakself.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
@end
