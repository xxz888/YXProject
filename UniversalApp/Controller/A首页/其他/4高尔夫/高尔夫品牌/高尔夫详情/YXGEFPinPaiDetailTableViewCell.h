//
//  YXGEFPinPaiDetailTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/18.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ClickGolfLikeBtnDelegate <NSObject>
-(void)clickLikeBtn:(BOOL)isZan golf_id:(NSString *)golf_id likeBtn:(UIButton *)likeBtn;
@end 
@interface YXGEFPinPaiDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
- (IBAction)likeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *gefTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *gnPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *mgPriceLbl;
@property (nonatomic,weak) id<ClickGolfLikeBtnDelegate> delegate;
@property(nonatomic,weak) NSString * golf_id;

@end

NS_ASSUME_NONNULL_END
