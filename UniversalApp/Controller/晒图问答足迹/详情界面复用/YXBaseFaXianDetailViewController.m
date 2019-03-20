//
//  YXBaseFaXianDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/26.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXBaseFaXianDetailViewController.h"

@interface YXBaseFaXianDetailViewController ()<UITextFieldDelegate,SDTimeLineCellDelegate>

@end

@implementation YXBaseFaXianDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.clickbtnHeight.constant = AxcAE_IsiPhoneX ? 70 : 40;
    _imageArr = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _pageArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (IBAction)clickPingLunAction:(id)sender {
    [_textField becomeFirstResponder];
    _textField.placeholder = @"开始评论...";
}
#pragma mark ========== tableview代理和所有方法 ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    
    cell.model = self.dataArray[indexPath.row];

    CGFloat height1 = cell.model.moreCountPL.integerValue <= 0 ? 0 : 20;
    [cell.showMoreCommentBtn setTitle:height1 == 0 ? @"" : @"显示更多回复 >>"  forState:UIControlStateNormal];
    cell.showMoreCommentBtn.hidden = height1 == 0;
    

    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            SDTimeLineCellModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.yxTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [cell setDidClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, SDTimeLineCell * cell) {
            weakSelf.textField.placeholder = [NSString stringWithFormat:@"  回复：%@", commentId];
            weakSelf.currentEditingIndexthPath = cell.indexPath;
            [weakSelf.textField becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentId;
            [weakSelf adjustTableViewToFitKeyboard];
            
        }];
        
        [cell setDidLongClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, SDTimeLineCell *cell,NSInteger tag) {
            //在此添加你想要完成的功能
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {}];
            QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                
                [weakSelf delePingLun:tag];
                
           
            }];
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"删除后将无法恢复，请慎重考虑" preferredStyle:QMUIAlertControllerStyleActionSheet];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController showWithAnimated:YES];
        }];
        cell.delegate = self;
    }
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    cell.starView.hidden = YES;
    

    return cell;
}
-(void)delePingLun:(NSInteger)tag{
    
}
-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        CGPoint location = [longRecognizer locationInView:self.yxTableView];
        NSIndexPath * indexPath = [self.yxTableView indexPathForRowAtPoint:location];
        //可以得到此时你点击的哪一行
        SDTimeLineCellModel * model = self.dataArray[indexPath.row];

 
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    SDTimeLineCellModel * model = self.dataArray[indexPath.row];
    CGFloat height1 = model.moreCountPL.integerValue <= 0 ? 0 : 20;

    return [self.yxTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]] + height1;
}
- (CGFloat)cellContentViewWith{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textField resignFirstResponder];
    self.textField.placeholder = nil;
}
- (void)keyboardNotification:(NSNotification *)notification{
    CGPoint offset = CGPointMake(0, 0);
    [self.yxTableView setContentOffset:offset animated:YES];

    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _textField.frame = textFieldRect;
    }];
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
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
    [_textField resignFirstResponder];
}

- (void)dealloc{
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTextField{
    
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    _textField.layer.borderWidth = 1;
    [_textField setFont:[UIFont systemFontOfSize:14]];
    //为textfield添加背景颜色 字体颜色的设置 还有block设置 , 在block中改变它的键盘样式 (当然背景颜色和字体颜色也可以直接在block中写)
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.textColor = [UIColor blackColor];
    _textField.tag = 8899;
    _textField.keyboardAppearance = UIKeyboardAppearanceDefault;
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
        [_textField becomeFirstResponder];
    }
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width_sd, textFieldH);
    
    BOOL isHave = NO;
    for (UIView * view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == 8899) {
            isHave = YES;
            break;
        }
    }
    if (isHave) {
        return;
    }else{
        //依次遍历self.view中的所有子视图
        for(id tmpView in [UIApplication sharedApplication].keyWindow.subviews){
            //找到要删除的子视图的对象
            if([tmpView isKindOfClass:[UITextField class]])
            {
                UITextField * tf = (UITextField *)tmpView;
                if(tf)   //判断是否满足自己要删除的子视图的条件
                {
                    [tf removeFromSuperview]; //删除子视图
                    break;  //跳出for循环，因为子视图已经找到，无须往下遍历
                }
            }
        }}
        [[UIApplication sharedApplication].keyWindow addSubview:_textField];

//    [_textField becomeFirstResponder];
//    [_textField resignFirstResponder];
}

-(void)initAllControl{
    kWeakSelf(self);
    self.title = @"详情";
    self.segmentIndex = 0;
    [self.yxTableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    self.yxTableView.estimatedRowHeight = 0;
    self.yxTableView.estimatedSectionHeaderHeight = 0;
    self.yxTableView.estimatedSectionFooterHeight = 0;
    self.yxTableView.tableFooterView = [[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeTop;
}
- (void)deallocsetContentViewValue{
    [self.textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
@end
