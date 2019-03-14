//
//  YXMineImageDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/23.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineImageDetailViewController.h"
#import "XHWebImageAutoSize.h"
@interface YXMineImageDetailViewController (){
    CGFloat imageHeight;
}
@end
@implementation YXMineImageDetailViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
     return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    if ([self.startDic[@"photo1"] length] >= 5) {
        imageHeight   = [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:self.startDic[@"photo1"]] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:400];
    }
    //初始化所有的控件
    [self initAllControl];
    [self addRefreshView:self.yxTableView];
    [self requestNewList];
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.lastDetailView) {
        //添加分隔线颜色设置
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXMineImageDetailHeaderView" owner:self options:nil];
        self.lastDetailView = [nib objectAtIndex:0];
    }
    [self.imageArr removeAllObjects];
    if ([self.startDic[@"photo1"] length] >= 5) {
        [self.imageArr addObject:self.startDic[@"photo1"]];
    }
    if ([self.startDic[@"photo2"] length] >= 5) {
        [self.imageArr addObject:self.startDic[@"photo2"]];
    }
    if ([self.startDic[@"photo3"] length] >= 5) {
        [self.imageArr addObject:self.startDic[@"photo3"]];
    }
    [self.lastDetailView setUpSycleScrollView:self.imageArr height:imageHeight];
    self.lastDetailView.rightCountLbl.text = [NSString stringWithFormat:@"%@/%ld",@"1",self.imageArr.count];
    self.lastDetailView.rightCountLbl.hidden = [self.lastDetailView.rightCountLbl.text isEqualToString:@"1/1"] ||
    [self.lastDetailView.rightCountLbl.text isEqualToString:@"1/0"];
    self.lastDetailView.titleLbl.text = self.startDic[@"user_name"];
    NSString * str1 = [(NSMutableString *)self.startDic[@"photo"] replaceAll:@" " target:@"%20"];
    [self.lastDetailView.titleImageView sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    self.lastDetailView.titleImageView.layer.masksToBounds = YES;
    self.lastDetailView.titleImageView.layer.cornerRadius = self.lastDetailView.titleImageView.frame.size.width / 2.0;
    self.lastDetailView.titleTimeLbl.text = [ShareManager timestampSwitchTime:[self.startDic[@"publish_time"] longLongValue] andFormatter:@""];
    self.lastDetailView.contentLbl.text =  [[NSString stringWithFormat:@"%@%@",self.startDic[@"content"] ? self.startDic[@"content"]:self.startDic[@"describe"],self.startDic[@"index"]] UnicodeToUtf8];
    self.lastDetailView.userInteractionEnabled = YES;
    self.lastDetailView.contentHeight.constant = [self getLblHeight:self.startDic];
    [ShareManager setLineSpace:9 withText:self.lastDetailView.contentLbl.text inLabel:self.lastDetailView.contentLbl tag:@""];

    
    self.lastDetailView.rightBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    return  self.lastDetailView;
}

-(CGFloat)getLblHeight:(NSDictionary *)dic{
    NSString * titleText = [NSString stringWithFormat:@"%@%@",dic[@"content"] ? dic[@"content"]:dic[@"describe"],dic[@"index"]];
    CGFloat height_size = [ShareManager inTextOutHeight:[titleText UnicodeToUtf8]];
    return height_size;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  100 + imageHeight + [self getLblHeight:self.startDic];
}
#pragma mark ========== 获取晒图评论列表 ==========
-(void)requestNewList{
    kWeakSelf(self);
    //请求评价列表 最新评论列表
    [YX_MANAGER requestPost_comment:[self getParamters:@"1" page:NSIntegerToNSString(self.requestPage)] success:^(id object) {
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
    [YX_MANAGER requestPost_comment:[self getParamters:@"2" page:NSIntegerToNSString(self.requestPage)] success:^(id object) {
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
    [self.yxTableView reloadData];
}
#pragma mark ========== 评论子评论 ==========
-(void)requestpost_comment_child:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestpost_comment_childPOST:dic success:^(id object) {
        self.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
#pragma mark ========== 更多评论 ==========
-(void)requestMoreCigar_comment_child:(NSString *)farther_id page:(NSString *)page{
    kWeakSelf(self);
    NSString * string = [NSString stringWithFormat:@"%@/%@",farther_id,page];
    [YX_MANAGER requestPost_comment_child:string success:^(id object) {
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
                
//                self.isReplayingComment = YES;
            } else {
                commentItemModel.firstUserId = kGetString(dic[@"user_id"]);
                commentItemModel.firstUserName =kGetString(dic[@"user_name"]);
                commentItemModel.commentString = [kGetString(dic[@"comment"]) UnicodeToUtf8];
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
    [YX_MANAGER requestPost_comment_praisePOST:@{@"comment_id":@([model.id intValue])} success:^(id object) {
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
                                     @"post_id":@([self.startDic[@"id"] intValue]),
                                     }];
            
        }
        self.textField.text = @"";
        self.textField.placeholder = nil;
        
        return YES;
    }
    return NO;
}
#pragma mark ========== 评论晒图 ==========
-(void)pinglunFatherPic:(NSDictionary *)dic{
    kWeakSelf(self);
    [YX_MANAGER requestPost_commentPOST:dic success:^(id object) {
        self.segmentIndex == 0 ? [weakself requestNewList] : [weakself requestHotList];
    }];
}
-(NSString *)getParamters:(NSString *)type page:(NSString *)page{
    return [NSString stringWithFormat:@"%@/0/%@/%@",type,self.startDic[@"id"],page];
}

@end
