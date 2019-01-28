//
//  YXFindQuestionTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXFindQuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (weak, nonatomic) IBOutlet UILabel *titleTagLbl1;
@property (weak, nonatomic) IBOutlet UILabel *titleTagLbl2;


@property (weak, nonatomic) IBOutlet UIImageView *midImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *midImageView3;

@property (weak, nonatomic) IBOutlet UIButton *mapBtn;


@property (weak, nonatomic) IBOutlet UILabel *pl1NameLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl2NameLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl1ContentLbl;
@property (weak, nonatomic) IBOutlet UILabel *pl2ContentLbl;
- (IBAction)searchAllPlBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *addPlImageView;

typedef void(^clickImageBlock)(NSInteger);
@property (nonatomic,copy) clickImageBlock clickImageBlock;
-(void)setCellValue:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
