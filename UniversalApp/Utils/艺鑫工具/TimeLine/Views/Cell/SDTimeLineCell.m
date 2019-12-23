//
//  SDTimeLineCell.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDTimeLineCell.h"


const CGFloat contentLabelFontSize = 13;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";
@interface SDTimeLineCell ()


@end
@implementation SDTimeLineCell


{
//    UIImageView *_iconView;
//    UILabel *_nameLable;
//    UILabel *_contentLabel;
//    SDWeiXinPhotoContainerView *_picContainerView;
//    UILabel *_timeLabel;
//    UIButton *_moreButton;
//    UIButton *_operationButton;
//
//    SDTimeLineCellOperationMenu *_operationMenu;
//    UIButton * _showMoreCommentBtn;
//
//    
//    UIButton *_huiFuButton;
//    UIView * _starView;

}

#pragma mark - 绘制Cell分割线

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        [self configTheme];
    }
    return self;
}

- (void)setup{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNotification object:nil];
    
    self.selectionStyle = 0;
    
    _iconView = [UIImageView new];
    _iconView.userInteractionEnabled = YES;
    _iconView.contentMode = 2;
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    
    _starView = [[UIView alloc]init];
    _starView.userInteractionEnabled = NO;
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont fontWithName:@"苹方-简" size:14];
    _contentLabel.numberOfLines = 0;

    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _operationButton.hidden = YES;
    
    
    
    _huiFuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_huiFuButton setTitle:@"回复" forState:UIControlStateNormal];
    [_huiFuButton setTitleColor:KDarkGaryColor forState:UIControlStateNormal];
    [_huiFuButton setFont:[UIFont systemFontOfSize:13]];
    [_huiFuButton addTarget:self action:@selector(huifuAction:) forControlEvents:UIControlEventTouchUpInside];
    [_huiFuButton setImage:[UIImage imageNamed:@"D黑色评论"] forState:UIControlStateNormal];
    
    
    _zanButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [_zanButton setTitle:@"赞" forState:UIControlStateNormal];
    [_zanButton setTitleColor:KDarkGaryColor forState:UIControlStateNormal];
    [_zanButton setFont:[UIFont systemFontOfSize:13]];
    [_zanButton addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _zanCountLable = [UILabel new];
    _zanCountLable.font = [UIFont systemFontOfSize:10];
    _zanCountLable.textColor = KBlackColor;
    _zanCountLable.text = @"";
    _zanCountLable.textAlignment = NSTextAlignmentLeft;
    
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];
    
    
    
    kWeakSelf(self);
    _commentView = [SDTimeLineCellCommentView new];
    [_commentView setDidClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow) {
        weakself.didClickCommentLabelBlock(commentId, rectInWindow, weakself);
    }];

    [_commentView setDidClickLongCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow,NSInteger tag) {
        weakself.didLongClickCommentLabelBlock(commentId, rectInWindow, weakself,tag);
    }];
    
    
    _showMoreCommentBtn = [UIButton new];
    
    [_showMoreCommentBtn setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_showMoreCommentBtn addTarget:self action:@selector(showMoreCommentAction) forControlEvents:UIControlEventTouchUpInside];
    _showMoreCommentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:11];
    _timeLabel.textColor = KDarkGaryColor;
    
    _operationMenu = [SDTimeLineCellOperationMenu new];
    __weak typeof(self) weakSelf = self;
    [_operationMenu setLikeButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
            [weakSelf.delegate didClickLikeButtonInCell:weakSelf];
        }
    }];
    
    
    [_operationMenu setCommentButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:)]) {
            [weakSelf.delegate didClickcCommentButtonInCell:weakSelf];
        }
    }];
    

    
    
    NSArray *views = @[_iconView, _nameLable,_starView, _contentLabel, _moreButton, _picContainerView, _timeLabel,_zanButton, _operationMenu, _commentView,_showMoreCommentBtn,_zanCountLable,_bottomLine];
    
    [self.contentView sd_addSubviews:views];
    
    
    
    UITapGestureRecognizer *tapGesturRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_iconView addGestureRecognizer:tapGesturRecognizer1];
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .widthIs(YX_MANAGER.isHaveIcon ? 0 :40)
    .heightIs(40);
    
    _nameLable.sd_layout
    .leftSpaceToView(YX_MANAGER.isHaveIcon ? contentView : _iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    
    _bottomLine.sd_layout
    .leftSpaceToView(self.contentView, 60)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 0)
    .heightIs(0.4);
 
    
    
    _starView.sd_layout
    .leftSpaceToView(_nameLable, margin)
    .topSpaceToView(contentView, margin)
    .widthIs(110)
    .heightIs(20);
    
    
    _timeLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, 5)
    .heightIs(15);

    

    
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_timeLabel, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    /*
    if (YX_MANAGER.isHaveIcon) {
        _contentLabel.sd_layout
        .centerYEqualToView(_nameLable)
        .leftSpaceToView(_nameLable, 3)
        .topEqualToView(_nameLable)
        .heightIs(18);

    }else{
        _contentLabel.sd_layout
        .leftEqualToView(_nameLable)
        .topSpaceToView(_nameLable, 5)
        .rightSpaceToView(contentView, margin)
        .autoHeightRatio(0);
    }
     
     
     _timeLabel.sd_layout
     .leftEqualToView(_contentLabel)
     .topSpaceToView(_picContainerView, margin)
     .heightIs(15);
     [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
     
     _contentLabel.sd_layout
     .leftEqualToView(_nameLable)
     .topSpaceToView(_nameLable, 5)
     .rightSpaceToView(contentView, margin)
     .autoHeightRatio(0);
*/
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(30);
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    

    
//    _operationButton.sd_layout
//    .rightSpaceToView(contentView, margin)
//    .centerYEqualToView(_timeLabel)
//    .heightIs(25)
//    .widthIs(25);
    
    _huiFuButton.sd_layout
    .rightSpaceToView(self.contentView, margin + 60)
    .centerYEqualToView(_timeLabel)
    .heightIs(20)
    .widthIs(20);
    
    _zanButton.sd_layout
    .rightSpaceToView(self.contentView, margin+20)
    .centerYEqualToView(_timeLabel)
    .heightIs(20)
    .widthIs(20);
    
    _zanCountLable.sd_layout
    .rightSpaceToView(self.contentView, margin -4)
    .centerYIs(38)
    .widthIs(20)
    .heightIs(10)
    ;
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(_contentLabel, margin); // 已经在内部实现高度自适应所以不需要再设置高度
    
    
    
    _showMoreCommentBtn.sd_layout
    .topSpaceToView(_commentView, 10)
    .rightSpaceToView(self.contentView, -10)
    .widthIs(200)
    .heightIs(20);
    
    
    
    _operationMenu.sd_layout
    .rightSpaceToView(_operationButton, 0)
    .heightIs(36)
    .centerYEqualToView(_operationButton)
    .widthIs(0);
    
    
}
-(void)tapAction:(id)sender{
    self.imgBlock(self);
}
-(void)fiveStarView:(NSString *)score view:(UIView *)view{
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,view.frame.size.width, view.frame.size.height)];
    label.text = score;
    label.font = [UIFont systemFontOfSize:13];
    [view addSubview:label];
    /*
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = HalfStar;
    starRateView.tag = 1;
    starRateView.currentScore = score;
    [view addSubview:starRateView];
     */
}
- (void)configTheme{

    
    
    _contentLabel.textColor = COLOR_333333;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(SDTimeLineCellModel *)model
{
    _model = model;
    
    [_commentView setupWithLikeItemsArray:model.likeItemsArray commentItemsArray:model.commentItemsArray];
    
//    _iconView.image = [UIImage imageNamed:model.iconName];
    
    NSString * str = [(NSMutableString *)model.iconName replaceAll:@" " target:@"%20"];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"zhanweitouxiang"]];
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = _iconView.frame.size.width / 2.0;
    _nameLable.text = model.name;
    _contentLabel.text = model.msgContent;
//    [ShareManager setLineSpace:5 withText:_contentLabel.text inLabel:_contentLabel tag:@""];
    _picContainerView.picPathStringsArray = model.picNamesArray;

/*
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    */
    _moreButton.sd_layout.heightIs(0);
    _moreButton.hidden = YES;
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
   
    UIView *bottomView;
    
    if (!model.commentItemsArray.count && !model.likeItemsArray.count) {
        bottomView = _timeLabel;
    } else {
        bottomView = _commentView;
    }

    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
    _timeLabel.text = [ShareManager timestampSwitchTime:model.commontTime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    
    _zanCountLable.text = model.praise_num;
    if ( [model.praise_num isEqualToString:@"0"]) {
        _zanCountLable.text = @"";
    }
    [self fiveStarView:model.score view:_starView];

    if ([model.praise isEqualToString:@"1"]) {
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"F蓝色已点赞"] forState:UIControlStateNormal];
    }else if ([model.praise isEqualToString:@"0"]){
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"F黑色未点赞"] forState:UIControlStateNormal];
    }
    
 
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

#pragma mark - private actions

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}
-(void)huifuAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:)]) {
        [self.delegate didClickcCommentButtonInCell:self];
    }
 
}
-(void)zanAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
        [self.delegate didClickLikeButtonInCell:self];
    }
}
-(void)showMoreCommentAction{
    if ([self.delegate respondsToSelector:@selector(showMoreComment:)]) {
        [self.delegate showMoreComment:self];
    }
}
- (void)operationButtonClicked
{
    [self postOperationButtonClickedNotification];
    _operationMenu.show = !_operationMenu.isShowing;
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _operationButton && _operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickedNotification];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSDTimeLineCellOperationButtonClickedNotification object:_operationButton];
}


@end

