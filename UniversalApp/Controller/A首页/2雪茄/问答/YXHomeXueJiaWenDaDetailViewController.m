//
//  YXHomeXueJiaWenDaDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/15.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaWenDaDetailViewController.h"
#import "MomentCell.h"
#import "HCInputBar.h"

@interface YXHomeXueJiaWenDaDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MomentCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *headImageView;

@property (strong, nonatomic) HCInputBar *inputBar;
@property (strong, nonatomic) UITextView *textWindow;

@end

@implementation YXHomeXueJiaWenDaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回复";
    self.view.backgroundColor = KWhiteColor;
    [self setUpUI];
    [self configKeyboard];
}
#pragma mark - UI
- (void)setUpUI
{
    // 表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, k_screen_width, k_screen_height-k_top_height - 50)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    //    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.dataSource = self;
    tableView.delegate = self;
    //    tableView.estimatedRowHeight = 0;
    //    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = self.tableHeaderView;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MomentCell";
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.moment =  self.moment;
    
    
    cell.delegate = self;
    cell.tag = indexPath.row;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 使用缓存行高，避免计算多次
    return self.moment.rowHeight;
}




- (void)configKeyboard{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    gestureRecognizer.delegate = self;
    gestureRecognizer.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationItem.title = @"聊天中";
    self.view.backgroundColor = [UIColor whiteColor];
    //添加用于显示表情和文字的textview
    [self.view addSubview:self.textWindow];
    //添加输入框键盘模块
    [self.view addSubview:self.inputBar];
    //块传值
    __weak typeof(self) weakSelf = self;
    [_inputBar showInputViewContents:^(NSString *contents) {
        weakSelf.textWindow.text = contents;
    }];
}
-(void)hideKeyboard:(id)sender{
    [_inputBar.inputView resignFirstResponder];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (HCInputBar *)inputBar {
    if (!_inputBar) {
        _inputBar = [[HCInputBar alloc]initWithStyle:DefaultInputBarStyle];
/*
        if (_row == 0) {
            _inputBar = [[HCInputBar alloc]initWithStyle:DefaultInputBarStyle];
        }else{
            _inputBar = [[HCInputBar alloc]initWithStyle:ExpandingInputBarStyle];
            _inputBar.expandingAry = @[[NSNumber numberWithInteger:ImgStyleWithEmoji],[NSNumber numberWithInteger:ImgStyleWithVideo],[NSNumber numberWithInteger:ImgStyleWithPhoto],[NSNumber numberWithInteger:ImgStyleWithCamera],[NSNumber numberWithInteger:ImgStyleWithVoice]];
        }
 */
        _inputBar.keyboard.showAddBtn = NO;
        [_inputBar.keyboard addBtnClicked:^{
            NSLog(@"我点击了添加按钮");
        }];
        _inputBar.placeHolder = @"输入新消息";
    }
    return _inputBar;
}
//- (void)dealloc {
//    _inputBar.keyboard = nil;
//}
/*
- (UITextView *)textWindow {
    if (!_textWindow) {
        _textWindow = [[UITextView alloc]initWithFrame:CGRectMake(10, 84,CGRectGetWidth(self.view.frame)-20 , 80)];
        _textWindow.text = @"发送的文字及表情显示在这里";
        _textWindow.layer.cornerRadius = 10;
        _textWindow.layer.masksToBounds = YES;
        _textWindow.layer.borderWidth = 1;
        _textWindow.font = [UIFont systemFontOfSize:15];
        _textWindow.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    return _textWindow;
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_inputBar.inputView resignFirstResponder];
}
@end
