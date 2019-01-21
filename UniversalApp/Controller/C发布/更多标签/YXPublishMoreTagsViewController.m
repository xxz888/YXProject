//
//  YXPublishMoreTagsViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/21.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXPublishMoreTagsViewController.h"
#import "YXGridView.h"
@interface YXPublishMoreTagsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;
@property(nonatomic, strong) QMUIGridView *gridView;

@end

@implementation YXPublishMoreTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.yxTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self setNavSearchView];
    
    [self createMiddleCollection:@[@"雪茄品牌",@"雪茄文化",@"运动"] titleTagArray:@[@"Cigar Brand",@"Culture",@"Sports"]];
}
#pragma mark ==========  搜索相关 ==========
-(void)setNavSearchView{
    UIColor *color =  YXRGBAColor(239, 239, 239);
    UITextField * searchBar = [[UITextField alloc] init];
    searchBar.frame = CGRectMake(50, 0, KScreenWidth - 50, 35);
    searchBar.backgroundColor = color;
    searchBar.layer.cornerRadius = 10;
    searchBar.layer.masksToBounds = YES;
    searchBar.placeholder = @"   🔍 搜索";
    
//    UIButton * btn = [UIButton buttonWithType:1];
//    [btn setTitle:@"取消" forState:0];
//    [btn setTitleColor:KDarkGaryColor forState:0];
//    btn.frame = CGRectMake(searchBar.frame.size.width - 50, 0, 50, 35);
//    [btn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
//    [searchBar addSubview:btn];
//
    
    [searchBar addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingDidBegin];
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = searchBar;
}
-(void)textField1TextChange:(UITextField *)tf{

}


//九宫格
- (void)createMiddleCollection:(NSArray *)titleArray titleTagArray:(NSArray *)titleTagArray{
    if (!self.gridView) {
        self.gridView = [[QMUIGridView alloc] init];
    }
     self.yxTableView.tableHeaderView = self.gridView;
    
    self.gridView.frame = CGRectMake(0, 0, KScreenWidth, 70);
    self.gridView.columnCount = 3;
    self.gridView.rowHeight = 60;
    self.gridView.separatorWidth = PixelOne;
    self.gridView.separatorColor = UIColorSeparator;
    self.gridView.separatorDashed = NO;
    
    // 将要布局的 item 以 addSubview: 的方式添加进去即可自动布局
    NSArray<UIColor *> *themeColors = @[UIColorTheme1, UIColorTheme2, UIColorTheme3, UIColorTheme4, UIColorTheme5, UIColorTheme6];
    for (NSInteger i = 0; i < 3; i++) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YXGridView" owner:self options:nil];
        YXGridView * view = [nib objectAtIndex:0];
        view.titleLbl.text = titleArray[i];
        view.titleTagLbl.text = titleTagArray[i];
        view.tag = i;
        //        view.backgroundColor = [themeColors[i] colorWithAlphaComponent:.7];
        [self.gridView addSubview:view];
        //view添加点击事件
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [view addGestureRecognizer:tapGesturRecognizer];
        
    }
}
-(void)tapAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
  
}
-(void)closeView{
    [self dismissViewControllerAnimated:YES completion:nil ];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.textLabel.text = @"#Cihiba";
    return cell;
}


@end
