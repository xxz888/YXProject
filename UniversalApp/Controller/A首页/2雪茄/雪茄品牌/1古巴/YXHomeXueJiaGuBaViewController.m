//
//  YXHomeXueJiaGuBaViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/6.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaGuBaViewController.h"
#import "YXGridView.h"
#import "YXHomeXueJiaPinPaiTableViewCell.h"
#import "YXHomeXueJiaPinPaiDetailViewController.h"
@interface YXHomeXueJiaGuBaViewController()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) QMUIGridView *gridView;
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * dataArrayTag;
@property (nonatomic,strong) NSMutableDictionary * dataDic;
@property (nonatomic,strong) NSMutableArray * indexArray;
@end
@implementation YXHomeXueJiaGuBaViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestCigar_brand:@"1"];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.indexArray = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];
    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaPinPaiTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaPinPaiTableViewCell"];
}
-(void)requestCigar_brand:(NSString *)type{
    kWeakSelf(self);
    [YX_MANAGER requestCigar_brand:type success:^(id object) {
        weakself.dataDic = [[NSMutableDictionary alloc]initWithDictionary:object];
        weakself.dataArray = [weakself userSorting:[NSMutableArray arrayWithArray:weakself.dataDic[@"brand_list"]]];
        [weakself createMiddleCollection];
        [weakself.yxTableView reloadData];
    }];
}
//九宫格
- (void)createMiddleCollection{
    [self.yxTableView.tableHeaderView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!self.gridView) {
        self.gridView = [[QMUIGridView alloc] init];
    }
    float height = 80;
    NSInteger count = [self.dataDic[@"hot_brand_list"] count];
    count = count <= 3 ? 1 : 2;
    self.gridView.frame = CGRectMake(10, 0, KScreenWidth-20, height*count);
    self.yxTableView.tableHeaderView = self.gridView;

    self.gridView.columnCount = 4;
    self.gridView.rowHeight = height;
    self.gridView.separatorWidth = PixelOne;
    self.gridView.separatorColor = KClearColor;
    self.gridView.separatorDashed = NO;

    for (NSInteger i = 0; i < [self.dataDic[@"hot_brand_list"] count]; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,0 , self.gridView.frame.size.width-20, self.gridView.frame.size.height)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        NSMutableString * str = [self.dataDic[@"hot_brand_list"][i][@"photo"] replaceAll:@" " target:@"%20"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        imageView.tag = i;//[self.dataDic[@"hot_brand_list"][@"id"] integerValue];
        [self.gridView addSubview:imageView];
        //view添加点击事件
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tapGesturRecognizer];
    }
}

//返回右侧索引标题数组
//这个标题的内容时和分区标题相对应
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexArray;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [_dataArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeXueJiaPinPaiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaPinPaiTableViewCell" forIndexPath:indexPath];

    
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.section][indexPath.row][@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [cell.cellImageView setContentMode:UIViewContentModeScaleAspectFit];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.cellLbl.text = self.dataArray[indexPath.section][indexPath.row][@"cigar_brand"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YXHomeXueJiaPinPaiTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [self requestCigar_brand_details:cell.cellLbl.text indexPath:indexPath];
}
-(void)tapAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
}

-(void)requestCigar_brand_details:(NSString *)cigar_brand indexPath:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    [YX_MANAGER requestCigar_brand_detailsPOST:@{@"cigar_brand":cigar_brand} success:^(id object) {
        UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
        YXHomeXueJiaPinPaiDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPinPaiDetailViewController"];
        VC.dicData = [NSMutableDictionary dictionaryWithDictionary:object];
        VC.dicStartData = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.section][indexPath.row]];
        [weakself.navigationController pushViewController:VC animated:YES];
    }];
}




























#pragma mark ========== 设置 右侧索引标题 对应的分区索引 ==========
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, 20)];
    //titile
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth, 20)];
    HeaderLabel.backgroundColor = YXRGBAColor(247, 249, 251);
    HeaderLabel.font = [UIFont boldSystemFontOfSize:13];
    HeaderLabel.textAlignment = NSTextAlignmentLeft;
    HeaderLabel.text = _indexArray[section];
    [view addSubview:HeaderLabel];
    
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    //返回 对应的分区索引
    return index-1;
}
//cell 内容的向右缩进 级别
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}
//第二步 根据第一步获取到的 拼音首字母 对汉字进行排序
-(NSMutableArray *)userSorting:(NSMutableArray *)modelArr{
    [_indexArray removeAllObjects];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i='A';i<='Z';i++){
        NSMutableArray *rulesArray = [[NSMutableArray alloc] init];
        NSString *str1=[NSString stringWithFormat:@"%c",i];
        for(int j=0;j<modelArr.count;j++){
            NSDictionary * dic = [modelArr objectAtIndex:j];  //这个model 是我自己创建的 里面包含用户的姓名 手机号 和 转化成功后的首字母
            if([[self getLetter:dic[@"cigar_brand"]] isEqualToString:str1]){
                [rulesArray addObject:dic];    //把首字母相同的人物model 放到同一个数组里面
                [modelArr removeObject:dic];   //model 放到 rulesArray 里面说明这个model 已经拍好序了 所以从总的modelArr里面删除
                j--;
            }else{
            }
        }
        if (rulesArray.count !=0) {
            [array addObject:rulesArray];
            [_indexArray addObject:[NSString stringWithFormat:@"%c",i]]; //把大写字母也放到一个数组里面
        }
    }
    if (modelArr.count !=0) {
        [array addObject:modelArr];
        [_indexArray addObject:@"#"];  //把首字母不是A~Z里的字符全部放到 array里面 然后返回
    }
    return array;
}
-(NSString *) getLetter:(NSString *) strInput{
    strInput = [strInput stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([strInput length]) {
        
        NSMutableString *ms = [[NSMutableString alloc] initWithString:strInput];
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
        
        NSArray *pyArray = [ms componentsSeparatedByString:@" "];
        if(pyArray && pyArray.count > 0){
            ms = [[NSMutableString alloc] init];
            for (NSString *strTemp in pyArray) {
                ms = [ms stringByAppendingString:[strTemp substringToIndex:1]];
            }
            
            return [[ms uppercaseString] substringToIndex:1];
        }
        
        ms = nil;
    }
    return nil;
}
@end
