//
//  YXMineHeaderView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/29.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface YXMineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *mineImageView;
@property (weak, nonatomic) IBOutlet UILabel *mineTitle;
@property (weak, nonatomic) IBOutlet UILabel *mineAdress;

@property (weak, nonatomic) IBOutlet UILabel *guanzhuCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *fensiCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *tieshuCountLbl;


typedef void(^guanzhuBlock)();
- (IBAction)guanzhuAction:(id)sender;
@property (nonatomic,copy) guanzhuBlock guanzhublock;





typedef void(^fensiBlock)();
- (IBAction)fensiAction:(id)sender;
@property (nonatomic,copy) fensiBlock fensiblock;

typedef void(^tieshuBlock)();
- (IBAction)tieshuAction:(id)sender;
@property (nonatomic,copy) tieshuBlock tieshublock;

typedef void(^editPersionBlock)();
- (IBAction)editPersonAction:(id)sender;
@property (nonatomic,copy) editPersionBlock editPersionblock;
@property (weak, nonatomic) IBOutlet UIButton *editPersonBtn;




@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;

@property (nonatomic,assign) BOOL whereCome;// NO为自己  YES为其他人
@property (nonatomic,copy) NSString * userId;



typedef void(^guanZhuOtherBlock)();
- (IBAction)guanZhuOtherAction:(id)sender;
@property (nonatomic,copy) guanZhuOtherBlock guanZhuOtherblock;

@end

NS_ASSUME_NONNULL_END
