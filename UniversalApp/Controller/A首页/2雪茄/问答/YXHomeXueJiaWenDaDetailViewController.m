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
#import "KeyBoardTableView.h"
@interface YXHomeXueJiaWenDaDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MomentCellDelegate>{
    BOOL _isHuiFuBool;
    Comment * _childComment;
}
@property (nonatomic, strong) KeyBoardTableView *tableView;
@property (nonatomic, strong) KeyBoardTableView *yxTableView;

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *headImageView;

@property (strong, nonatomic) HCInputBar *inputBar;
@property (strong, nonatomic) UITextView *textWindow;
@property (nonatomic, strong) NSMutableDictionary * parDic;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation YXHomeXueJiaWenDaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回复";
    self.view.backgroundColor = KWhiteColor;
    [self setUpUI];
    [self configKeyboard];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestAnserList];
}
#pragma mark ========== 请求回答列表 ==========
-(void)requestAnserList{
    NSString * par = [NSString stringWithFormat:@"%@/%@",self.moment.startId,@"1"];
    //获取回答列表
    kWeakSelf(self);
    [YX_MANAGER requestAnswerListGET:par success:^(id object) {
        [_dataArray removeAllObjects];
        for (NSDictionary * dic in object) {
            Comment *comment = [[Comment alloc] init];
            comment.userName = dic[@"user_name"];
            comment.userId = dic[@"user_id"];
            comment.text = dic[@"answer"];
            comment.answerChildId = dic[@"id"];
            comment.pk = 0;
            [_dataArray addObject:comment];
            if ([dic[@"child"] count] > 0) {
                for (NSInteger i = 0 ; i < [dic[@"child"] count] ; i++) {
                    NSDictionary * childDic =  dic[@"child"][i];
                    Comment *commentChild = [[Comment alloc] init];
                    commentChild.pk = 1;
                    commentChild.aim_id = childDic[@"aim_id"];
                    commentChild.aim_name = childDic[@"aim_name"];
                    commentChild.userChildId = childDic[@"user_id"];
                    commentChild.userChildName = childDic[@"user_name"];
                    commentChild.userName = [NSString stringWithFormat:@"       %@ 回复 %@",childDic[@"user_name"],childDic[@"aim_name"]] ;
                    commentChild.userId = childDic[@"user_id"];
                    commentChild.text = childDic[@"answer"];
                    commentChild.answerChildId = childDic[@"answer_id"];
                    if (i+1 == [dic[@"child"] count]) {
                        commentChild.isLastChildBool = YES;
                    }
                    [_dataArray addObject:commentChild];
                }
            }
        }
        [weakself.moment setValue:_dataArray forKey:@"commentList"];
        [weakself.tableView reloadData];
    }];
}
-(void)commonAction{
    
}
#pragma mark ========== 发布回答 ==========
-(void)requestFaBuHuiDa:(NSMutableDictionary *)dic{
    [dic setValue:self.moment.startId forKey:@"question_id"];
    if (!dic[@"question_id"]) {
        [QMUITips showError:@"问题不存在,请返回重新进入" inView:self.tableView hideAfterDelay:1];
        return;
    }else if (!dic[@"answer"] || [dic[@"answer"] length] < 0){
        [QMUITips showError:@"请输入回答" inView:self.tableView hideAfterDelay:1];
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestFaBuHuiDaPOST:dic success:^(id object) {
        [weakself requestAnserList];
    }];
}
#pragma mark ========== 请求子回答列表 ==========
-(void)requestAnserChildList:(NSString *)str{
    NSString * par = [NSString stringWithFormat:@"%@/%@",str,@"1"];
    kWeakSelf(self);
    //获取回答列表
    [YX_MANAGER requestAnswer_childListGET:par success:^(id object) {
        [_dataArray removeAllObjects];
                for (NSInteger i = 0 ; i < [object count] ; i++) {
                    NSDictionary * childDic =  object[i];
                    Comment *commentChild = [[Comment alloc] init];
                    commentChild.pk = 1;
                    commentChild.aim_id = childDic[@"aim_id"];
                    commentChild.aim_name = childDic[@"aim_name"];
                    commentChild.userChildId = childDic[@"user_id"];
                    commentChild.userChildName = childDic[@"user_name"];
                    commentChild.userName = [NSString stringWithFormat:@"       %@ 回复 %@",childDic[@"user_name"],childDic[@"aim_name"]] ;
                    commentChild.userId = childDic[@"user_id"];
                    commentChild.text = childDic[@"answer"];
                    commentChild.answerChildId = childDic[@"answer_id"];
                    if (i+1 == [object count]) {
                        commentChild.isLastChildBool = YES;
                    }else{
                        commentChild.isLastChildBool = NO;
                    }
                    [_dataArray addObject:commentChild];
                }
        [self.moment setValue:_dataArray forKey:@"commentList"];
        [weakself.tableView reloadData];

   
    }];
}
#pragma mark ========== 发布子回答 ==========
-(void)requestFaBuHuiDaChild:(NSMutableDictionary *)dic{
    if (!dic[@"answer_id"]) {
        [QMUITips showError:@"问题不存在,请返回重新进入" inView:self.tableView hideAfterDelay:1];
        return;
    }else if (!dic[@"answer"] || [dic[@"answer"] length] < 0){
        [QMUITips showError:@"请输入回答" inView:self.tableView hideAfterDelay:1];
        return;
    }
    kWeakSelf(self);
    [YX_MANAGER requestFaBuHuiDa_childPOST:dic success:^(id object) {
         [weakself requestAnserList];
    }];
}
#pragma mark ========== 代理 ==========
-(void)didSelectComment:(Comment *)comment{
    _isHuiFuBool = YES;
    _childComment = comment;
    [_inputBar.inputView becomeFirstResponder];
    if (_isHuiFuBool && _childComment.userName) {
        if (_childComment.pk == 0) {
            _inputBar.placeHolder = [_childComment.userName concate:@"回复: "];
        }else{
            NSArray * array = [_childComment.userChildName split:@"回复"];
            _inputBar.placeHolder = [array[0] concate:@"回复:"];
        }
    }
}
#pragma mark - UI
- (void)setUpUI
{
    _isHuiFuBool = NO;
    _parDic = [[NSMutableDictionary alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    // 表格
    KeyBoardTableView *tableView = [[KeyBoardTableView alloc] initWithFrame:CGRectMake(0, 64, k_screen_width, k_screen_height-k_top_height - 50)];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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



- (void)didMoreBtn:(NSInteger)tag{
    [self requestAnserChildList:intToNSString(tag)];
}


- (void)configKeyboard{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    gestureRecognizer.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    [self.view addGestureRecognizer:gestureRecognizer];

    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //添加用于显示表情和文字的textview
    [self.view addSubview:self.textWindow];
    //添加输入框键盘模块
    [self.view addSubview:self.inputBar];
    //块传值
    kWeakSelf(self);
    [_inputBar showInputViewContents:^(NSString *contents) {
        [_parDic removeAllObjects];
        if (_isHuiFuBool) {
            [_parDic setValue:_childComment.answerChildId forKey:@"answer_id"];
            [_parDic setValue:contents forKey:@"answer"];
            [_parDic setValue:_childComment.userId forKey:@"aim_id"];
            if (_childComment.pk == 0) {
                [_parDic setValue:_childComment.userName  forKey:@"aim_name"];
            }else{
                NSArray * array = [_childComment.userChildName split:@"回复"];
                [_parDic setValue:array[0]  forKey:@"aim_name"];
            }
            [weakself requestFaBuHuiDaChild:_parDic];
        }else{
            [_parDic setValue:contents forKey:@"answer"];
            [weakself requestFaBuHuiDa:_parDic];
            
        }

    
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 收到通知、监控键盘

- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
//    CGFloat offset = self.moment.rowHeight - (self.view.frame.size.height - kbHeight);
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
//    CGFloat offset = (self.inputBar.frame.origin.y+self.inputBar.frame.size.height) - (self.tableView.frame.size.height - kbHeight);
//
//    if (self.view.frame.size.height - self.moment.rowHeight < kbHeight) {
//        self.view.frame = CGRectMake(0.0f, -abs(self.view.frame.size.height - self.moment.rowHeight), self.view.frame.size.width, self.view.frame.size.height);
//
//    }
//    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
//    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//    //将视图上移计算好的偏移
//    if(offset > 0) {
//        [UIView animateWithDuration:duration animations:^{
//            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//        }];
//    }
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    // 键盘动画时间
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}


-(void)hideKeyboard:(id)sender{
//    [_inputBar.inputView resignFirstResponder];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (HCInputBar *)inputBar {
    if (!_inputBar) {
        _inputBar = [[HCInputBar alloc]initWithStyle:DefaultInputBarStyle];
        _inputBar.keyboard.showAddBtn = NO;
        [_inputBar.keyboard addBtnClicked:^{
            NSLog(@"我点击了添加按钮");
        }];
        _inputBar.placeHolder = @"输入评论";
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
