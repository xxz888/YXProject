//
//  YXFindFootTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXFindFootTableViewCell : UITableViewCell
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
- (IBAction)searchAllPlBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *addPlImageView;


-(void)setCellValue:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
