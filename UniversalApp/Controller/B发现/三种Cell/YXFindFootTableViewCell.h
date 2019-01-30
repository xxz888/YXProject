//
//  YXFindFootTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




@class YXFindFootTableViewCell;
typedef void(^jumpDetailVC1)(YXFindFootTableViewCell *);
@interface YXFindFootTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *topView;


@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView;
@property (weak, nonatomic) IBOutlet UITextView *titleTagtextView;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;


@property (weak, nonatomic) IBOutlet UILabel *pl1NameLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl2NameLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl1ContentLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl2ContentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *addPlImageView;
typedef void(^clickImageBlock)(NSInteger);
@property (nonatomic,copy) clickImageBlock clickImageBlock;


-(void)setCellValue:(NSDictionary *)dic;



- (IBAction)searchAllPlBtnAction:(id)sender;
- (IBAction)addPlBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (nonatomic,copy) jumpDetailVC1 jumpDetailVC;






typedef void(^clickFootZanBlock)(YXFindFootTableViewCell *);
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
- (IBAction)likeBtnAction:(id)sender;
@property (nonatomic,copy) clickFootZanBlock zanblock;
@end

NS_ASSUME_NONNULL_END
