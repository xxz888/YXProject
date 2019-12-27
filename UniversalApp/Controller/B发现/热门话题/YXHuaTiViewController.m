//
//  YXHuaTiViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/6.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "YXHuaTiViewController.h"
#import "YXHuaTiLeftTableViewCell.h"
#import "YXHuaTiRightTableViewCell.h"
#import "YXFindSearchTagDetailViewController.h"
@interface YXHuaTiViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * rightArray;
@property(nonatomic,strong)NSMutableArray * leftArray;
@property(nonatomic,strong)NSString * selectRow;


@end

@implementation YXHuaTiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavSearchView];
    self.searchHeaderView.findTextField.placeholder = @"话题、关键字";
    [self setUI];
    [self requestFindTag];
    [self requestGetTagLIst:self.selectRow];
}
-(void)setUI{
    [self.leftTableView registerNib:[UINib nibWithNibName:@"YXHuaTiLeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHuaTiLeftTableViewCell"];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"YXHuaTiRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHuaTiRightTableViewCell"];
    [self addRefreshView:self.rightTableView];
      self.leftArray = [[NSMutableArray alloc]init];
      self.rightArray = [[NSMutableArray alloc]init];
    self.isShowLiftBack = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView.tag==1001?self.leftArray.count:self.rightArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.tag==1001?50:78;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1001) {
        YXHuaTiLeftTableViewCell * leftCell = [tableView dequeueReusableCellWithIdentifier:@"YXHuaTiLeftTableViewCell" forIndexPath:indexPath];
        NSDictionary * leftDic = self.leftArray[indexPath.row];
        leftCell.titleLbl.text = leftDic[@"type"];
        //字体颜色和背景色
        leftCell.titleLbl.textColor = [self.selectRow integerValue] == [leftDic[@"id"] integerValue]? COLOR_333333 : COLOR_999999;
        leftCell.backgroundColor = [self.selectRow integerValue] == [leftDic[@"id"] integerValue] ? KWhiteColor:COLOR_F5F5F5;
//        leftCell.titleLbl.backgroundColor = [self.selectRow integerValue] == [leftDic[@"id"] integerValue] ? SEGMENT_COLOR : KWhiteColor;
        leftCell.titleLbl.font = [self.selectRow integerValue] == [leftDic[@"id"] integerValue]? BOLDSYSTEMFONT(14.0f) : SYSTEMFONT(14.0f);
        return leftCell;
    }else{
        YXHuaTiRightTableViewCell * rightCell = [tableView dequeueReusableCellWithIdentifier:@"YXHuaTiRightTableViewCell" forIndexPath:indexPath];
        NSDictionary * rightDic = self.rightArray[indexPath.row];
        rightCell.titleLbl.text = rightDic[@"tag"];
        rightCell.countLbl.text = [kGetString(rightDic[@"post_number"]) append:@"帖子"];
        return rightCell;

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==1001){
        //刷新两个个cell
        NSInteger selectRowInger = 0;
        for (NSInteger i = 0; i<self.leftArray.count; i++) {
            if ([self.selectRow integerValue] == [self.leftArray[i][@"id"] integerValue]) {
                selectRowInger = i;
            }
        }
        NSIndexPath * oldIndex = [NSIndexPath indexPathForRow:selectRowInger inSection:0];
        NSDictionary * leftDic = self.leftArray[indexPath.row];
        self.selectRow = kGetString(leftDic[@"id"]);
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:oldIndex,nil] withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [self requestGetTagLIst:self.selectRow];
    }else{
        NSString * string = self.rightArray[indexPath.row][@"tag"];
        [self searchTagInfo:string];
    }

}
-(void)searchTagInfo:(NSString *)string{
    kWeakSelf(self);
    if ([string contains:@"#"]) {string = [string split:@"#"][1];}
         [YX_MANAGER  requestSearchFind_all:@{@"key":string,@"key_unicode":string,@"page":@"1",@"type":@"3"} success:^(id object) {
             if ([object count] > 0) {
                 YXFindSearchTagDetailViewController * VC = [[YXFindSearchTagDetailViewController alloc] init];
                 VC.type = @"3";
                 VC.key = string;
                 VC.startDic = [NSDictionary dictionaryWithDictionary:object[0]];
                 VC.startArray = [NSArray arrayWithArray:object];
                 [weakself.navigationController pushViewController:VC animated:YES];
             }else{
                 [QMUITips showInfo:@"无此标签的信息"];
             }
         }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchTagInfo:textField.text];
    return YES;
}
-(void)headerRereshing{
    [super headerRereshing];
    [self requestGetTagLIst:self.selectRow];
}
-(void)footerRereshing{
    [super footerRereshing];
    [self requestGetTagLIst:self.selectRow];

}
#pragma mark ========== 先请求tag列表,获取发现页标签数据 ==========
-(void)requestFindTag{
    kWeakSelf(self);
    [self.leftArray removeAllObjects];
    [YX_MANAGER requestGet_users_find_tag:@"" success:^(id object) {
        [weakself.leftArray addObjectsFromArray:object];
        [weakself.leftTableView reloadData];
        weakself.selectRow = kGetString(weakself.leftArray[0][@"id"]);

        [weakself requestGetTagLIst:weakself.selectRow];
    }];
}
#pragma mark ========== 根据标签请求列表 ==========
-(void)requestGetTagLIst:(NSString *)page{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@",page,NSIntegerToNSString(self.requestPage)];
    [YX_MANAGER requestGetTagList:par success:^(id object) {
        weakself.rightArray = [weakself commonAction:object dataArray:weakself.rightArray];
        [weakself.rightTableView reloadData];
    }];
}
-(void)textField1TextChange:(UITextField *)tf{
    if (tf.text.length != 0) {
          kWeakSelf(self);
          [YX_MANAGER requestGetTagList_Tag:@{@"type":self.selectRow,@"key":tf.text,@"page":@"1"} success:^(id object) {
            
          }];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
