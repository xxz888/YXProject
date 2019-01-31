//
//  YXHomeXueJiaDetailTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/7.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "TableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ClickLikeBtnDelegate <NSObject>
-(void)clickLikeBtn:(BOOL)isZan cigar_id:(NSString *)cigar_id likeBtn:(UIButton *)likeBtn;
@end 
@interface YXHomeXueJiaDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *section2TitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *section2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *section2Lbl1;
@property (weak, nonatomic) IBOutlet UILabel *section2Lbl2;
@property (weak, nonatomic) IBOutlet UILabel *section2Lbl3;
@property (weak, nonatomic) IBOutlet UILabel *section2Lbl4;
@property (weak, nonatomic) IBOutlet UILabel *section2Lbl5;
@property (weak, nonatomic) IBOutlet UILabel *section2Lbl6;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (nonatomic,weak) id<ClickLikeBtnDelegate> delegate;
@property(nonatomic,weak) NSString * cigar_id;
@property (weak, nonatomic) IBOutlet UIStackView *stackView1;


@property (nonatomic,assign) BOOL whereCome;//yes为足迹进来 no为正常进入  足迹进来
@end

NS_ASSUME_NONNULL_END
