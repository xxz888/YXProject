//
//  YXMineAndFindBaseViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineAndFindBaseViewController.h"
#import "XHWebImageAutoSize.h"
#import "HGPersonalCenterViewController.h"
#import "YXFindSearchTagDetailViewController.h"
#import "ZInputToolbar.h"
#import "UIView+LSExtension.h"
#import "YXPublishImageViewController.h"
@interface YXMineAndFindBaseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZInputToolbarDelegate>{
    CGFloat _autoPLHeight;
    BOOL _tagSelectBool;
    NSDictionary * shareDic;
}
@property (nonatomic, strong) ZInputToolbar *inputToolbar;

@end

@implementation YXMineAndFindBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _autoPLHeight = 0;
    [self tableviewCon];
    [self addRefreshView:self.yxTableView];

}

#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    self.dataArray = [[NSMutableArray alloc]init];
    self.yxTableView = [[UITableView alloc]init];
    [self.view addSubview:self.yxTableView];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    self.yxTableView.estimatedRowHeight = 0;
    self.yxTableView.estimatedSectionHeaderHeight = 0;
    self.yxTableView.estimatedSectionFooterHeight = 0;
    
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindImageTableViewCell"];
    
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindQuestionTableViewCell"];
    
     [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFirstFindImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFirstFindImageTableViewCell"];
    
}
#pragma mark ========== tableview代理方法 ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"obj"] integerValue];
    NSDictionary * dicTag = nil;
    if ([self.dataArray count] > indexPath.row){
        dicTag = [self.dataArray objectAtIndex:indexPath.row];
    }
    if (tag == 1 || tag == 4) {
        return [YXFirstFindImageTableViewCell cellDefaultHeight:dicTag];
    }else if (tag == 3){
        return [YXFindQuestionTableViewCell cellMoreHeight:dicTag];
    }else{
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"obj"] integerValue];
    if (tag == 1) {
        return [self customImageData:dic indexPath:indexPath whereCome:NO];
    }else if (tag == 2){
        return [self customImageData:dic indexPath:indexPath whereCome:NO];
    }else{
        return nil;
    }
}
#pragma mark 字典转化字符串
-(NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
#pragma mark ========== 图片 ==========
-(YXFirstFindImageTableViewCell *)customImageData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath whereCome:(BOOL)whereCome{
    YXFirstFindImageTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFirstFindImageTableViewCell" forIndexPath:indexPath];
//    if(cell == nil)
//    {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//
//    }
    
    cell.tagId = [dic[@"id"] integerValue];
    cell.titleImageView.tag = indexPath.row;
    kWeakSelf(self);
    cell.shareblock = ^(YXFirstFindImageTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        UserInfo * userInfo = curUser;
        BOOL isOwn = [cell.dataDic[@"user_id"] integerValue] == [userInfo.id integerValue];
        shareDic = [NSDictionary dictionaryWithDictionary:cell.dataDic];
        [weakself addGuanjiaShareViewIsOwn:isOwn isWho:@"1" tag:cell.tagId startDic:cell.dataDic];
    };
    cell.clickImageBlock = ^(NSInteger tag) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
    cell.clickTagblock = ^(NSString * string) {
        kWeakSelf(self);
        _tagSelectBool = YES;
        [YX_MANAGER requestSearchFind_all:@{@"key":string,@"key_unicode":[string utf8ToUnicode],@"page":@"1",@"type":@"2"} success:^(id object) {
            if ([object count] > 0) {
                YXFindSearchTagDetailViewController * VC = [[YXFindSearchTagDetailViewController alloc] init];
                VC.type = @"3";
                VC.key = object[0][@"tag"];
                VC.startDic = [NSDictionary dictionaryWithDictionary:object[0]];
                [weakself.navigationController pushViewController:VC animated:YES];
            }else{
                [QMUITips showInfo:@"无此标签的信息"];
            }
            _tagSelectBool = NO;
        }];
    };
    cell.clickDetailblock = ^(NSInteger tag, YXFirstFindImageTableViewCell * cell) {
        NSIndexPath * indexPathSelect = [weakself.yxTableView indexPathForCell:cell];
        [weakself tableView:weakself.yxTableView didSelectRowAtIndexPath:indexPathSelect];
    };
    cell.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [cell setCellValue:dic];
    return cell;
}

#pragma mark - ZInputToolbarDelegate
-(void)inputToolbar:(ZInputToolbar *)inputToolbar sendContent:(NSString *)sendContent {
   
    
    [self finishTextView:inputToolbar.textInput];
    // 清空输入框文字
    [self.inputToolbar sendSuccessEndEditing];
}


#pragma mark - UITextFieldDelegate
-(void)finishTextView:(UITextView *)textField{
    if (textField.text.length) {
        if (textField.tag >= 10000) {
            NSString * inputText = textField.text;
            NSInteger index = textField.tag -10000 ;
            YXFindQuestionTableViewCell * cell = [self.yxTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            UserInfo * userInfo = curUser;
            NSString * str = @"";
            if ([cell.plLbl.text concate:@"\n"] && ![cell.plLbl.text isEqualToString:@""]) {
                str = [NSString stringWithFormat:@"\n%@:%@",userInfo.username,textField.text];
            }else{
                str = [NSString stringWithFormat:@"%@:%@",userInfo.username,textField.text];
            }
            cell.plLbl.text = [cell.plLbl.text append:str];
            cell.pl1Height.constant = [ShareManager inTextOutHeight:cell.plLbl.text lineSpace:9 fontSize:14];
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[index]];
            [dic setValue:floatToNSString(cell.pl1Height.constant) forKey:@"plHeight"];
            [dic setValue:cell.plLbl.text forKey:@"plContent"];
            [self.dataArray replaceObjectAtIndex:index withObject:dic];
            NSIndexPath *indexRow = [self.yxTableView indexPathForCell:cell];
            [self.yxTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexRow, nil] withRowAnimation:UITableViewRowAnimationNone];
            [self requestFaBuHuiDa:@{
                                     @"answer":[inputText utf8ToUnicode],
                                     @"question_id":@(cell.tagId)
                                     }];
        }else{
            NSString * inputText = textField.text;
            NSInteger index = textField.tag ;
            YXFindImageTableViewCell * cell = [self.yxTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [self coustom1:cell tf:textField index:index];
            if (cell.whereCome) {
                    [self pinglunFatherPic_zuji:@{@"comment":[inputText utf8ToUnicode] ,
                                                  @"track_id":@(cell.tagId),
                                                  } tview:textField];
                }else{
                    [self pinglunFatherPic_shaitu:@{@"comment":[inputText utf8ToUnicode],
                                                    @"post_id":@(cell.tagId)}];
                }
        }
    }
}
-(void)coustom1:(YXFindImageTableViewCell *)cell tf:(UITextView *)textField index:(NSInteger)index{
    UserInfo * userInfo = curUser;
    NSString * str = @"";
    if ([cell.plLbl.text concate:@"\n"] && ![cell.plLbl.text isEqualToString:@""]) {
        str = [NSString stringWithFormat:@"\n%@:%@",userInfo.username,textField.text];
    }else{
        str = [NSString stringWithFormat:@"%@:%@",userInfo.username,textField.text];
    }
    cell.plLbl.text = [cell.plLbl.text append:str];
    cell.pl1Height.constant = [ShareManager inTextOutHeight:cell.plLbl.text lineSpace:9 fontSize:14];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[index]];
    [dic setValue:floatToNSString(cell.pl1Height.constant) forKey:@"plHeight"];
    [dic setValue:cell.plLbl.text forKey:@"plContent"];
    [self.dataArray replaceObjectAtIndex:index withObject:dic];
    NSIndexPath *indexRow = [self.yxTableView indexPathForCell:cell];
    [self.yxTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexRow, nil] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark ========== 评论晒图 ==========
-(void)pinglunFatherPic_shaitu:(NSDictionary *)dic{
    [YX_MANAGER requestPost_commentPOST:dic success:^(id object) {
        
    }];
}
#pragma mark ========== 评论足迹 ==========
-(void)pinglunFatherPic_zuji:(NSDictionary *)dic tview:(UITextView *)textfield{
    kWeakSelf(self);
    [YX_MANAGER requestPingLunFoot:dic success:^(id object) {
    }];
}
#pragma mark ========== 发布回答 ==========
-(void)requestFaBuHuiDa:(NSDictionary *)dic{
    [YX_MANAGER requestFaBuHuiDaPOST:dic success:^(id object) {
        
    }];
}
#pragma mark ========== 问答 ==========
-(YXFindQuestionTableViewCell *)customQuestionData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXFindQuestionTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFindQuestionTableViewCell" forIndexPath:indexPath];
    cell.tagId = [dic[@"id"] integerValue];
    cell.titleImageView.tag = indexPath.row;
    cell.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    kWeakSelf(self);
    cell.clickImageBlock = ^(NSInteger tag) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
    cell.zanblock1 = ^(YXFindQuestionTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
        [weakself requestDianZan_WenDa_Action:indexPath1];
    };
    cell.jumpDetail1VCBlock = ^(YXFindQuestionTableViewCell * cell) {
        NSIndexPath * indexPathSelect = [weakself.yxTableView indexPathForCell:cell];
        [weakself tableView:weakself.yxTableView didSelectRowAtIndexPath:indexPathSelect];
    };
    cell.shareQuestionblock = ^(YXFindQuestionTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        UserInfo * userInfo = curUser;
        BOOL isOwn = [cell.dataDic[@"user_id"] integerValue] == [userInfo.id integerValue];
        shareDic = [NSDictionary dictionaryWithDictionary:cell.dataDic];
        [weakself addGuanjiaShareViewIsOwn:isOwn isWho:@"2" tag:cell.tagId startDic:cell.dataDic];
    };
    //自定义cell的回调，获取要展开/收起的cell。刷新点击的cell
    cell.showMoreTextBlock = ^(YXFindQuestionTableViewCell * cell,NSMutableDictionary * dataDic){
        NSIndexPath *indexRow = [weakself.yxTableView indexPathForCell:cell];
        NSMutableArray * copyArr = [NSMutableArray arrayWithArray:weakself.dataArray];
        for (NSInteger i = 0; i < copyArr.count; i++) {
            if ([copyArr[i][@"id"] integerValue] == [dataDic[@"id"] integerValue]) {
                [weakself.dataArray replaceObjectAtIndex:i withObject:dataDic];
                
            }
        }
        [weakself.yxTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexRow, nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.addPlActionblock = ^(YXFindQuestionTableViewCell * cell) {
        if (![userManager loadUserInfo]) {
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        NSIndexPath *indexRow = [weakself.yxTableView indexPathForCell:cell];
        if ([self.parentViewController isKindOfClass:[HGSegmentedPageViewController class]]) {
            [self tableView:weakself.yxTableView didSelectRowAtIndexPath:indexRow];
        }else{
            [weakself setupTextField];
            weakself.inputToolbar.textInput.tag = indexRow.row + 10000;
            [weakself.inputToolbar.textInput becomeFirstResponder];
        }


    };
    cell.clickTagblock = ^(NSString * string) {
        kWeakSelf(self);
        _tagSelectBool = YES;
        [YX_MANAGER requestSearchFind_all:@{@"key":string,@"key_unicode":[string utf8ToUnicode],@"page":@"1",@"type":@"2"} success:^(id object) {
            if ([object count] > 0) {
                YXFindSearchTagDetailViewController * VC = [[YXFindSearchTagDetailViewController alloc] init];
                VC.type = @"3";
                VC.key = object[0][@"tag"];
                VC.startDic = [NSDictionary dictionaryWithDictionary:object[0]];
                [weakself.navigationController pushViewController:VC animated:YES];
            }else{
                [QMUITips showInfo:@"无此标签的信息"];
            }
            _tagSelectBool = NO;
        }];
    };
    [cell setCellValue:dic];
    return cell;
}
-(void)commonDidVC:(NSIndexPath *)indexPath{
  
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZan_Image_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        [weakself requestAction];
    }];
}
#pragma mark ========== 足迹点赞 ==========
-(void)requestDianZan_ZuJI_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* track_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestDianZanFoot:@{@"track_id":track_id} success:^(id object) {
        [weakself requestAction];
    }];
}
#pragma mark ========== 问答点赞 ==========
-(void)requestDianZan_WenDa_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* track_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPraise_question:track_id success:^(id object) {
        [weakself requestAction];
    }];
}
-(void)requestAction{
    
}
#pragma mark ========== 头像点击 ==========
-(void)clickUserImageView:(NSString *)userId{
     UserInfo *userInfo = curUser;
    if ([userInfo.id isEqualToString:userId]) {
        self.navigationController.tabBarController.selectedIndex = 4;
        return;
    }
//     UIStoryboard * stroryBoard5 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
//     YXMineViewController * mineVC = [stroryBoard5 instantiateViewControllerWithIdentifier:@"YXMineViewController"];
     HGPersonalCenterViewController * mineVC = [[HGPersonalCenterViewController alloc]init];
     mineVC.userId = userId;
     mineVC.whereCome = YES;    //  YES为其他人 NO为自己
     [self.navigationController pushViewController:mineVC animated:YES];
    
}
#pragma mark ========== tableViewcell点击 ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tagSelectBool) {
        return;
    }
    [self.inputToolbar.textInput resignFirstResponder];
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"obj"] integerValue];
    if (tag == 1) {//晒图
        YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
        //因为详情界面复用了外边cell，只是少了评论区和点击评论，所以这个高度要减去评论和点击评论的高度
        CGFloat h = [YXFindImageTableViewCell cellNewDetailNeedHeight:dic whereCome:NO];
        VC.headerViewHeight = h;
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (tag == 3){//问答
        YXHomeXueJiaQuestionDetailViewController * VC = [[YXHomeXueJiaQuestionDetailViewController alloc]init];
        CGFloat h = [YXFindQuestionTableViewCell cellNewDetailNeedHeight:dic];
        VC.headerViewHeight = h;
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (tag == 4){//足迹
        NSDictionary * dic = self.dataArray[indexPath.row];
        YXMineFootDetailViewController * VC = [[YXMineFootDetailViewController alloc]init];
        //因为详情界面复用了外边cell，只是少了评论区和点击评论，所以这个高度要减去评论和点击评论的高度
        CGFloat h = [YXFindImageTableViewCell cellNewDetailNeedHeight:dic whereCome:YES];
        VC.headerViewHeight = h;
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        YXFindImageTableViewCell * cell = [self.yxTableView cellForRowAtIndexPath:indexPath];
        VC.height = cell.imvHeight.constant;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

-(Moment *)setTestInfo:(NSDictionary *)dic{
    NSMutableArray *commentList = nil;
    Moment *moment = [[Moment alloc] init];
    moment.praiseNameList = nil;
    moment.userName = dic[@"user_name"];
    moment.text = dic[@"title"];
    moment.detailText = dic[@"question"];
    moment.index = dic[@"index"];
    moment.time = dic[@"publish_date"] ? [dic[@"publish_date"] longLongValue] : [dic[@"publish_time"] longLongValue];
    moment.singleWidth = (KScreenWidth-30)/3;
    moment.singleHeight = 100;
    moment.location = @"";
    moment.isPraise = NO;
    moment.photo =dic[@"user_photo"];
    moment.startId = dic[@"id"];
    NSMutableArray * imgArr = [NSMutableArray array];
    if ([dic[@"pic1"] length] >= 5) {
        [imgArr addObject:dic[@"pic1"]];
    }
    if ([dic[@"pic2"] length] >= 5) {
        [imgArr addObject:dic[@"pic2"]];
    }
    if ([dic[@"pic3"] length] >= 5) {
        [imgArr addObject:dic[@"pic3"]];
    }
    moment.imageListArray = [NSMutableArray arrayWithArray:imgArr];
    moment.fileCount = imgArr.count;
    
    commentList = [[NSMutableArray alloc] init];
    int num = (int)[dic[@"answer"] count];
    for (int j = 0; j < num; j ++) {
        Comment *comment = [[Comment alloc] init];
        comment.userName = dic[@"answer"][j][@"user_name"];
        comment.text =  dic[@"answer"][j][@"answer"];
        comment.time = 1487649503;
        comment.pk = j;
        [commentList addObject:comment];
    }
    [moment setValue:commentList forKey:@"commentList"];
    return moment;
}
#pragma mark ========== 分享 ==========
- (void)addGuanjiaShareViewIsOwn:(BOOL)isOwn isWho:(NSString *)isWho tag:(NSInteger)tagId startDic:(NSDictionary *)startDic{
    
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    kWeakSelf(self);
    // 如果你的 item 是确定的，则可以直接通过 items 属性来显示，如果 item 需要经过一些判断才能确定下来，请看第二个示例
    NSMutableArray * itemsArray1 = [[NSMutableArray alloc]init];
    [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_add") title:@"编辑" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
        [moreOperationController hideToBottom];
        YXPublishImageViewController * imageVC = [[YXPublishImageViewController alloc]init];
        imageVC.startDic = [[NSMutableDictionary alloc]initWithDictionary:startDic];
        [weakself presentViewController:imageVC animated:YES completion:nil];
    }]],
    [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_remove") title:@"删除" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
        [moreOperationController hideToBottom];
        if ([isWho isEqualToString:@"1"]) {
            [YX_MANAGER requestDel_ShaiTU:NSIntegerToNSString(tagId) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
                [weakself requestAction];
            }];
        }else if ([isWho isEqualToString:@"2"]){
            [YX_MANAGER requestDel_WenDa:NSIntegerToNSString(tagId) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
                
                [weakself requestAction];
            }];
        }else if ([isWho isEqualToString:@"3"]){
            [YX_MANAGER requestDel_ZuJi:NSIntegerToNSString(tagId) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
                
                [weakself requestAction];
            }];
        }
    }]],
    [itemsArray1 addObject:[QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_report") title:@"举报" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
        [moreOperationController hideToBottom];
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"不友善内容" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            [QMUITips showSucceed:@"举报成功"];
        }];
        QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"有害内容" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            [QMUITips showSucceed:@"举报成功"];
        }];
        QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:@"抄袭内容" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            [QMUITips showSucceed:@"举报成功"];
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController addAction:action3];
        [alertController addAction:action4];
        [alertController showWithAnimated:YES];
    }]];
    
    if (isOwn) {
        [itemsArray1 removeObjectAtIndex:2];
        if (![isWho isEqualToString:@"1"]) {
            [itemsArray1 removeObjectAtIndex:0];
        }
    }else{
        [itemsArray1 removeObjectAtIndex:0];
        [itemsArray1 removeObjectAtIndex:0];
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    moreOperationController.items = @[
                                      // 第一行
                                      @[
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"分享给微信好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                                  [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_WechatSession obj:shareDic];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"分享到朋友圈" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                              [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine obj:shareDic];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_QQ") title:@"分享给QQ好友" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                                       [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_QQ obj:shareDic];
                                          }],
                                          [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareQzone") title:@"分享到QQ空间" handler:^(QMUIMoreOperationController *moreOperationController, QMUIMoreOperationItemView *itemView) {
                                              [moreOperationController hideToBottom];
                                                     [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_Qzone obj:shareDic];
                                          }],
                                          ],
                                      itemsArray1
                                      // 第二行
                         
                                      ];
    [moreOperationController showFromBottom];

}

#pragma mark 分享按钮
- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title startDic:(NSDictionary *)dic{
    [shareView tappedCancel];
    NSLog(@"当前点击:%@",title);
    kWeakSelf(self);
    if ([title isEqualToString:@"微信"]) {
        [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_WechatSession obj:shareDic];
    }
    if ([title isEqualToString:@"朋友圈"]) {
        [[ShareManager sharedShareManager] shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine obj:shareDic];
    }
    if ([title isEqualToString:@"删除"]) {
        if ([shareView.isWho isEqualToString:@"1"]) {
            [YX_MANAGER requestDel_ShaiTU:NSIntegerToNSString(shareView.tag) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];
                [weakself requestAction];
            }];
        }else if ([shareView.isWho isEqualToString:@"2"]){
            [YX_MANAGER requestDel_WenDa:NSIntegerToNSString(shareView.tag) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];

                [weakself requestAction];
            }];
        }else if ([shareView.isWho isEqualToString:@"3"]){
            [YX_MANAGER requestDel_ZuJi:NSIntegerToNSString(shareView.tag) success:^(id object) {
                [QMUITips showSucceed:@"删除成功"];

                [weakself requestAction];
            }];
        }
    }
    if ([title isEqualToString:@"举报"]) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"不友善内容" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            [QMUITips showSucceed:@"举报成功"];

        }];
        QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"有害内容" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            [QMUITips showSucceed:@"举报成功"];

        }];
        QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:@"抄袭内容" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            [QMUITips showSucceed:@"举报成功"];

        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController addAction:action3];
        [alertController addAction:action4];

        [alertController showWithAnimated:YES];
    }
    if([title isEqualToString:@"编辑"]){
        YXPublishImageViewController * imageVC = [[YXPublishImageViewController alloc]init];
        imageVC.startDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [weakself presentViewController:imageVC animated:YES completion:nil];
    }
}

- (void)setupTextField{
    [self.inputToolbar removeFromSuperview];
    self.inputToolbar = [[ZInputToolbar alloc] initWithFrame:CGRectMake(0,self.view.height, self.view.width, 60)];
    self.inputToolbar.textViewMaxLine = 5;
    self.inputToolbar.delegate = self;
    self.inputToolbar.placeholderLabel.text = @"开始评论...";
    [self.view addSubview:self.inputToolbar];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (void)keyboardNotification:(NSNotification *)notification{
//    CGPoint offset = CGPointMake(0, 0);
//    [self.yxTableView setContentOffset:offset animated:YES];
    
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    kWeakSelf(self);
    [UIView animateWithDuration:0.25 animations:^{
        weakself.textField.frame = textFieldRect;
    }];
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        //[self adjustTableViewToFitKeyboard];
    }
}

#pragma mark ========== 以下为所有自适应和不常用的方法 ==========
- (void)adjustTableViewToFitKeyboard{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.yxTableView cellForRowAtIndexPath:self.currentEditingIndexthPath];
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_textField resignFirstResponder];
    [_textField removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
@end
