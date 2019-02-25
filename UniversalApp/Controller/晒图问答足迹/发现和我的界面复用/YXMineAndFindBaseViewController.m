//
//  YXMineAndFindBaseViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineAndFindBaseViewController.h"
#import "XHWebImageAutoSize.h"
@interface YXMineAndFindBaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YXMineAndFindBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindImageTableViewCell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindQuestionTableViewCell"];
    
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
        return [YXFindImageTableViewCell cellDefaultHeight:dicTag whereCome:tag==1?NO:YES];

        //根据isShowMoreText属性判断cell的高度
//        if ([dicTag[@"isShowMoreText"] isEqualToString:@"1"]){
//            return [YXFindImageTableViewCell cellDefaultHeight:dicTag whereCome:tag==1?NO:YES];
//        }else{
//            return [YXFindImageTableViewCell cellDefaultHeight:dicTag whereCome:tag==1?NO:YES];
//        }
//        return 0;
    }else if (tag == 3){
        return [YXFindQuestionTableViewCell cellMoreHeight:dicTag];

        //根据isShowMoreText属性判断cell的高度
//        if ([dicTag[@"isShowMoreText"] isEqualToString:@"1"]){
//            return [YXFindQuestionTableViewCell cellMoreHeight:dicTag];
//        }else{
//            return [YXFindQuestionTableViewCell cellMoreHeight:dicTag];
//        }
//        return 0;
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
    }else if (tag == 3){
        return [self customQuestionData:dic indexPath:indexPath];
    }else if (tag == 4){
        return [self customImageData:dic indexPath:indexPath whereCome:YES];
    }else{
        return nil;
    }
}
#pragma mark ========== 图片 ==========
-(YXFindImageTableViewCell *)customImageData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath whereCome:(BOOL)whereCome{
    YXFindImageTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFindImageTableViewCell" forIndexPath:indexPath];
    
    NSString * str = [(NSMutableString *) (whereCome ? dic[@"pic1"]:dic[@"photo1"]) replaceAll:@" " target:@"%20"];
    [cell.midImageView sd_setImageWithURL:[NSURL URLWithString:str] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        /**  缓存image size */
        [XHWebImageAutoSize storeImageSize:image forURL:imageURL completed:^(BOOL result) {
            /** reload */
            if(result)  [self.yxTableView xh_reloadDataForURL:imageURL];
        }];
        
    }];
    
    cell.titleImageView.tag = indexPath.row;
    kWeakSelf(self);
    cell.clickImageBlock = ^(NSInteger tag) {
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
    cell.zanblock = ^(YXFindImageTableViewCell * cell) {
        NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
        
        whereCome ?  [weakself requestDianZan_ZuJI_Action:indexPath1] : [weakself requestDianZan_Image_Action:indexPath1];
    };
    cell.shareblock = ^(YXFindImageTableViewCell * cell) {
        [weakself addGuanjiaShareView];
    };
    cell.jumpDetailVCBlock = ^(YXFindImageTableViewCell * cell) {
        NSIndexPath * indexPathSelect = [weakself.yxTableView indexPathForCell:cell];
        [weakself tableView:weakself.yxTableView didSelectRowAtIndexPath:indexPathSelect];
    };
    //自定义cell的回调，获取要展开/收起的cell。刷新点击的cell
    cell.showMoreTextBlock = ^(YXFindImageTableViewCell * cell,NSMutableDictionary * dataDic){
        NSIndexPath *indexRow = [weakself.yxTableView indexPathForCell:cell];
        NSMutableArray * copyArr = [NSMutableArray arrayWithArray:weakself.dataArray];
        for (NSInteger i = 0; i < copyArr.count; i++) {
            if ([copyArr[i][@"id"] integerValue] == [dataDic[@"id"] integerValue]) {
                [weakself.dataArray replaceObjectAtIndex:i withObject:dataDic];
            }
        }
        
        [weakself.yxTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexRow, nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    cell.whereCome = whereCome;
    [cell setCellValue:dic whereCome:whereCome];
    return cell;
}
#pragma mark ========== 问答 ==========
-(YXFindQuestionTableViewCell *)customQuestionData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXFindQuestionTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFindQuestionTableViewCell" forIndexPath:indexPath];
    cell.titleImageView.tag = indexPath.row;
    cell.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    kWeakSelf(self);
    cell.clickImageBlock = ^(NSInteger tag) {
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
    cell.jumpDetail1VCBlock = ^(YXFindQuestionTableViewCell * cell) {
        NSIndexPath * indexPathSelect = [weakself.yxTableView indexPathForCell:cell];
        [weakself tableView:weakself.yxTableView didSelectRowAtIndexPath:indexPathSelect];
    };
    cell.shareQuestionblock = ^(YXFindQuestionTableViewCell * cell) {
        [weakself addGuanjiaShareView];
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
-(void)requestAction{
    
}
#pragma mark ========== 头像点击 ==========
-(void)clickUserImageView:(NSString *)userId{
     UserInfo *userInfo = curUser;
    if ([userInfo.id isEqualToString:userId]) {
        self.navigationController.tabBarController.selectedIndex = 4;
        return;
    }
     UIStoryboard * stroryBoard5 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];
     YXMineViewController * mineVC = [stroryBoard5 instantiateViewControllerWithIdentifier:@"YXMineViewController"];
     mineVC.userId = userId;
     mineVC.whereCome = YES;    //  YES为其他人 NO为自己
     [self.navigationController pushViewController:mineVC animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"obj"] integerValue];
    if (tag == 1) {//晒图
        YXMineImageDetailViewController * VC = [[YXMineImageDetailViewController alloc]init];
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        YXFindImageTableViewCell * cell = [self.yxTableView cellForRowAtIndexPath:indexPath];
        VC.height = cell.imvHeight.constant;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (tag == 3){//问答
        UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
        YXHomeXueJiaQuestionDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaQuestionDetailViewController"];
        YX_MANAGER.isHaveIcon = YES;
        VC.moment = [self setTestInfo:dic];
        
        [self.navigationController pushViewController:VC animated:YES];
    }else if (tag == 4){//足迹
        NSDictionary * dic = self.dataArray[indexPath.row];
        YXMineFootDetailViewController * VC = [[YXMineFootDetailViewController alloc]init];
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        YXFindImageTableViewCell * cell = [self.yxTableView cellForRowAtIndexPath:indexPath];
        VC.height = cell.imvHeight.constant;
        [self.navigationController pushViewController:VC animated:YES];    }
}

-(Moment *)setTestInfo:(NSDictionary *)dic{
    NSMutableArray *commentList = nil;
    Moment *moment = [[Moment alloc] init];
    moment.praiseNameList = nil;
    moment.userName = dic[@"user_name"];
    moment.text = dic[@"title"];
    moment.detailText = dic[@"question"];
    moment.time = dic[@"publish_date"] ? [dic[@"publish_date"] longLongValue] : [dic[@"publish_time"] longLongValue];
    moment.singleWidth = 500;
    moment.singleHeight = 315;
    moment.location = @"";
    moment.isPraise = NO;
    moment.photo =dic[@"user_photo"];
    moment.startId = dic[@"id"];
    moment.fileCount = 3;
    moment.imageListArray = [NSMutableArray arrayWithObjects:
                             dic[@"pic1"],
                             dic[@"pic2"],
                             dic[@"pic3"], nil];
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
- (void)addGuanjiaShareView {
    NSArray *shareAry = @[@{@"image":@"shareView_wx",
                            @"title":@"微信"},
                          @{@"image":@"shareView_friend",
                            @"title":@"朋友圈"},
                          @{@"image":@"shareView_wb",
                            @"title":@"新浪微博"},
                          @{@"image":@"shareView_qq",
                            @"title":@"QQ"},
                          @{@"image":@"shareView_rr",
                            @"title":@"其他"},
                          @{@"image":@"",
                            @"title":@""},
                          @{@"image":@"",
                            @"title":@""},
                          @{@"image":@"share_copyLink",
                            @"title":@"删除"},
                          @{@"image":@"",
                            @"title":@""}];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 54)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, headerView.frame.size.width, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享到";
    [headerView addSubview:label];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, headerView.frame.size.width, 0.5)];
    lineLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    [headerView addSubview:lineLabel];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 0.5)];
    lineLabel1.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    
    HXEasyCustomShareView *shareView = [[HXEasyCustomShareView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    shareView.headerView = headerView;
    float height = [shareView getBoderViewHeight:shareAry firstCount:7];
    shareView.boderView.frame = CGRectMake(0, 0, shareView.frame.size.width, height);
    shareView.middleLineLabel.hidden = YES;
    [shareView.cancleButton addSubview:lineLabel1];
    shareView.cancleButton.frame = CGRectMake(shareView.cancleButton.frame.origin.x, shareView.cancleButton.frame.origin.y, shareView.cancleButton.frame.size.width, 54);
    shareView.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [shareView.cancleButton setTitleColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
    [shareView setShareAry:shareAry delegate:self];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
    
}

#pragma mark HXEasyCustomShareViewDelegate

- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title {
    NSLog(@"当前点击:%@",title);
}



@end
