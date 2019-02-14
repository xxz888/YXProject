//
//  YXFindImageTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface YXFindImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleTagLbl;
@property (weak, nonatomic) IBOutlet UITextView *titleTagtextView;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;


@property (weak, nonatomic) IBOutlet UILabel *pl1NameLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl2NameLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl1ContentLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl2ContentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *addPlImageView;


//cell方法
-(void)setCellValue:(NSDictionary *)dic whereCome:(BOOL)whereCome;

//回话 查看全部 添加评论    跳转详情
typedef void(^jumpDetailVCBlock)(YXFindImageTableViewCell *);
- (IBAction)searchAllPlBtnAction:(id)sender;
@property (nonatomic,copy) jumpDetailVCBlock jumpDetailVCBlock;



//点击头像
typedef void(^clickImageBlock)(NSInteger);
@property (nonatomic,copy) clickImageBlock clickImageBlock;

//爱心
typedef void(^clickImageZanBlock)(YXFindImageTableViewCell *);
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
- (IBAction)likeBtnAction:(id)sender;
@property (nonatomic,copy) clickImageZanBlock zanblock;


//分享
typedef void(^clickShareBlock)(YXFindImageTableViewCell *);
- (IBAction)shareAction:(id)sender;
@property (nonatomic,copy) clickShareBlock shareblock;

@end

NS_ASSUME_NONNULL_END
