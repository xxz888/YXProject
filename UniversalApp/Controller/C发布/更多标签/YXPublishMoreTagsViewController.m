//
//  YXPublishMoreTagsViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishMoreTagsViewController.h"
#import "YXGridView.h"
@interface YXPublishMoreTagsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CBSegmentView * sliderSegmentView;
    UITextField * searchBar;
}
@property(nonatomic,strong)NSMutableArray * tagArray;
@property(nonatomic,strong)NSString * type;

@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property(nonatomic, strong) QMUIGridView *gridView;
@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation YXPublishMoreTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.yxTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.yxTableView.tableHeaderView = [self headerView];
    [self setNavSearchView];
    self.tagArray = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self requestGetTag];
    [self requestFindTag];

}
#pragma mark ========== 先请求tag列表,获取发现页标签数据 ==========
-(void)requestFindTag{
    kWeakSelf(self);
    [self.tagArray removeAllObjects];
    [YX_MANAGER requestGet_users_find_tag:@"" success:^(id object) {
        for (NSDictionary * dic in object) {
            [weakself.tagArray addObject:dic[@"type"]];
        }
        [sliderSegmentView setTitleArray:weakself.tagArray withStyle:CBSegmentStyleSlider];
        [weakself requestGetTagLIst:kGetString(object[0][@"id"])];
    }];
}
#pragma mark ========== 根据标签请求列表 ==========
-(void)requestGetTagLIst:(NSString *)page{
    kWeakSelf(self);
    NSString * par = [NSString stringWithFormat:@"%@/%@",page,@"1"];
    [YX_MANAGER requestGetTagList:par success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}
-(UIView *)headerView{
    kWeakSelf(self);
    sliderSegmentView = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    sliderSegmentView.titleChooseReturn = ^(NSInteger x) {
        weakself.type = NSIntegerToNSString(x+1);
        [weakself requestGetTagLIst:weakself.type];
    };
    return sliderSegmentView;
}

#pragma mark ========== 搜索标签 ==========
-(void)searchTagResult{
    kWeakSelf(self);
    [YX_MANAGER requestGetTagList_Tag:@{@"type":@"1",@"key":searchBar.text,@"page":@"1"} success:^(id object) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:object];
        [weakself.yxTableView reloadData];
    }];
}











#pragma mark ==========  搜索相关 ==========
-(void)setNavSearchView{
    UIColor *color =  YXRGBAColor(239, 239, 239);
    if (!searchBar) {
        searchBar = [[UITextField alloc] init];
    }
    searchBar.frame = CGRectMake(50, 0, KScreenWidth - 50, 35);
    searchBar.backgroundColor = color;
    searchBar.layer.cornerRadius = 10;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = @"   🔍 搜索";
    [searchBar addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = searchBar;
}
-(void)textField1TextChange:(UITextField *)tf{
    if (tf.text.length == 0) {
        [self requestGetTagLIst:self.type];
    }else{
        [self searchTagResult];
    }
}
-(void)closeView{
    [self dismissViewControllerAnimated:YES completion:nil ];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.textLabel.text =  [NSString stringWithFormat:@"#%@",self.dataArray[indexPath.row][@"tag"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    [self dismissViewControllerAnimated:YES completion:^{
        weakself.tagBlock(weakself.dataArray[indexPath.row]);
    }];
}


@end
