//
//  YXMineAllViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineAllViewController.h"
#import "YXMineEssayTableViewCell.h"
#import "YXMineEssayDetailViewController.h"
#import "YXMineImageDetailViewController.h"
#import "YXMineViewController.h"
#import "YXMineImageCollectionViewCell.h"

#import "YXFindImageTableViewCell.h"
#import "YXFindQuestionTableViewCell.h"
#import "YXFindFootTableViewCell.h"
#import "YXHomeXueJiaQuestionDetailViewController.h"
#import "Moment.h"
#import "Comment.h"
#import "YXMineFootDetailViewController.h"
#define user_id_BOOL self.userId && ![self.userId isEqualToString:@""]

@interface YXMineAllViewController ()<UITableViewDelegate,UITableViewDataSource>{
}
@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic, assign)BOOL isMainScroll;
@property(nonatomic, assign)BOOL isCellScroll;
@end

@implementation YXMineAllViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建tableview
    [self tableviewCon];
    [self addRefreshView:self.yxTableView];
    user_id_BOOL ? [self requestOther_AllList] : [self requestMine_AllList];
}
-(void)headerRereshing{
    [super headerRereshing];
    user_id_BOOL ? [self requestOther_AllList] : [self requestMine_AllList];
}
-(void)footerRereshing{
    [super footerRereshing];
    user_id_BOOL ? [self requestOther_AllList] : [self requestMine_AllList];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark ========== 我自己的所有 ==========
-(void)requestMine_AllList{
    kWeakSelf(self);
    [YX_MANAGER requestGetSersAllList:NSIntegerToNSString(self.requestPage) success:^(id object) {
         weakself.dataArray = [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}
#pragma mark ========== 其他用户的所有 ==========
-(void)requestOther_AllList{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@",self.userId,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGetSers_Other_AllList:par success:^(id object){
        weakself.dataArray =  [weakself commonAction:object dataArray:weakself.dataArray];
        [weakself.yxTableView reloadData];
    }];
}

#pragma mark ========== 创建tableview ==========
-(void)tableviewCon{
    self.dataArray = [[NSMutableArray alloc]init];
    CGFloat heightKK = 90;
    self.yxTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 175 -kTopHeight - heightKK) style:0];
    [self.view addSubview:self.yxTableView];
    self.yxTableView.delegate = self;
    self.yxTableView.dataSource= self;
    self.yxTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.yxTableView.showsVerticalScrollIndicator = NO;
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindImageTableViewCell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindQuestionTableViewCell"];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXFindFootTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFindFootTableViewCell"];
}

#pragma mark ========== tableview代理方法 ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSInteger tag = [dic[@"obj"] integerValue];
    if (tag == 1) {
        return 670;
    }else if (tag == 3){
        return 340;
    }else if(tag == 4){
        return 500;
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
    cell.titleImageView.tag = indexPath.row;
    kWeakSelf(self);
    cell.clickImageBlock = ^(NSInteger tag) {
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
    cell.zanblock = ^(YXFindImageTableViewCell * cell) {
        NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
        [weakself requestDianZan_Image_Action:indexPath1];
    };
    [cell setCellValue:dic whereCome:whereCome];
    return cell;
}
#pragma mark ========== 问答 ==========
-(YXFindQuestionTableViewCell *)customQuestionData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXFindQuestionTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFindQuestionTableViewCell" forIndexPath:indexPath];
    cell.topView.hidden = YES;
    cell.topViewConstraint.constant = 0;
    cell.titleImageView.tag = indexPath.row;
    kWeakSelf(self);
    cell.clickImageBlock = ^(NSInteger tag) {
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
  
    [cell setCellValue:dic];
    return cell;
}
#pragma mark ========== 足迹 ==========
-(YXFindFootTableViewCell *)cunstomFootData:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    YXFindFootTableViewCell * cell = [self.yxTableView dequeueReusableCellWithIdentifier:@"YXFindFootTableViewCell" forIndexPath:indexPath];
    cell.topView.hidden = YES;
    cell.topViewConstraint.constant = 0;
    cell.titleImageView.tag = indexPath.row;
    kWeakSelf(self);
    cell.clickImageBlock = ^(NSInteger tag) {
        [weakself clickUserImageView:kGetString(weakself.dataArray[tag][@"user_id"])];
    };
    [cell setCellValue:dic];

    cell.jumpDetailVC = ^(YXFindFootTableViewCell * cell) {
        NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
        [weakself commonDidVC:indexPath1];
    };
    cell.zanblock = ^(YXFindFootTableViewCell * cell) {
        NSIndexPath * indexPath1 = [weakself.yxTableView indexPathForCell:cell];
        [weakself requestDianZan_ZuJI_Action:indexPath1];
    };
    return cell;
}
-(void)commonDidVC:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];
    YXMineFootDetailViewController * VC = [[YXMineFootDetailViewController alloc]init];
    VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    YX_MANAGER.isHaveIcon = NO;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ========== 晒图点赞 ==========
-(void)requestDianZan_Image_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* post_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestPost_praisePOST:@{@"post_id":post_id} success:^(id object) {
        user_id_BOOL ? [weakself requestOther_AllList] : [weakself requestMine_AllList];
    }];
}
#pragma mark ========== 足迹点赞 ==========
-(void)requestDianZan_ZuJI_Action:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    NSString* track_id = kGetString(self.dataArray[indexPath.row][@"id"]);
    [YX_MANAGER requestDianZanFoot:@{@"track_id":track_id} success:^(id object) {
        user_id_BOOL ? [weakself requestOther_AllList] : [weakself requestMine_AllList];
    }];
}
-(void)clickUserImageView:(NSString *)userId{
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
        YX_MANAGER.isHaveIcon = NO;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (tag == 2){//文章
        YX_MANAGER.isHaveIcon = NO;
        YXMineEssayDetailViewController * VC = [[YXMineEssayDetailViewController alloc]init];
        VC.startDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (tag == 3){//问答
        UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
        YXHomeXueJiaQuestionDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaQuestionDetailViewController"];
        VC.moment = [self setTestInfo:dic];
        YX_MANAGER.isHaveIcon = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (tag == 4){//足迹
        [self commonDidVC:indexPath];
    }
}

-(Moment *)setTestInfo:(NSDictionary *)dic{
    NSMutableArray *commentList = nil;
    Moment *moment = [[Moment alloc] init];
    moment.praiseNameList = nil;
    moment.userName = dic[@"user_name"];
    moment.text = dic[@"title"];
    moment.time = [dic[@"publish_date"] longLongValue];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect startFrame = scrollView.frame;
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%.2f",offsetY);
    if (offsetY > 100) {
        [self.yxTableView setFrame: CGRectMake(0, 0, KScreenWidth, KScreenHeight - 175 -kTopHeight - 90)];

    }else{
        [self.yxTableView setFrame: CGRectMake(0, 0, KScreenWidth, KScreenHeight - 175 -kTopHeight - 90)];
    }
}
@end
