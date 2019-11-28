//
//  YXMineHeaderView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/29.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScale.h"

NS_ASSUME_NONNULL_BEGIN
@interface YXMineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *mineImageView;
@property (weak, nonatomic) IBOutlet UILabel *mineTitle;
@property (weak, nonatomic) IBOutlet UILabel *mineAdress;
@property (weak, nonatomic) IBOutlet UIStackView *myStackView;
@property (weak, nonatomic) IBOutlet UIStackView *otherStackView;
@property (weak, nonatomic) IBOutlet UIView *fasixinView;
@property (weak, nonatomic) IBOutlet UIButton *shezhiBtn;

@property (weak, nonatomic) IBOutlet UILabel *guanzhuCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *fensiCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *tieshuCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *tieshubtn;
@property (weak, nonatomic) IBOutlet UIButton *fasixinBtn;
@property (weak, nonatomic) IBOutlet UILabel *otherguanzhucountlbl;
@property (weak, nonatomic) IBOutlet UILabel *otherfensicountlbl;


@property (strong, nonatomic) NSString * otherImageViewUrl;

typedef void(^fasixinBlock)();
- (IBAction)fasixinAction:(id)sender;
@property (nonatomic,copy) fasixinBlock fasixinblock;

typedef void(^guanzhuBlock)();
- (IBAction)guanzhuAction:(id)sender;
@property (nonatomic,copy) guanzhuBlock guanzhublock;



typedef void(^SetBlock)();
@property (nonatomic,copy) SetBlock setblock;


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


typedef void(^settingBlock)();
@property (nonatomic,copy) settingBlock settingBlock;



@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;

@property (nonatomic,assign) BOOL whereCome;// NO为自己  YES为其他人
@property (nonatomic,copy) NSString * userId;



typedef void(^guanZhuOtherBlock)();
- (IBAction)guanZhuOtherAction:(id)sender;
@property (nonatomic,copy) guanZhuOtherBlock guanZhuOtherblock;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

typedef void(^MineBackVCBlock)();
@property (nonatomic,copy) MineBackVCBlock mineBackVCBlock;
@property (nonatomic, strong) ImageScale *imageScale;

typedef void(^mineClickImageBlock)();
@property (nonatomic,copy) mineClickImageBlock mineClickImageblock;

typedef void(^jifenShopBlock)();
@property (nonatomic,copy) jifenShopBlock jifenShopblock;

@property (weak, nonatomic) IBOutlet UILabel *qianmingLbl;
@property (weak, nonatomic) IBOutlet UIView *cellHeaderView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;


typedef void(^qiandaoBlock)();
@property (nonatomic,copy) qiandaoBlock qiandaoblock;
@property (weak, nonatomic) IBOutlet UIButton *qiandaoBtn;
- (IBAction)qiandaoAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *shangchengBtn;
typedef void(^shangchengBlock)();
@property (nonatomic,copy) shangchengBlock shangchengblock;

@property (weak, nonatomic) IBOutlet UIButton *dongtaiBtn;
- (IBAction)dongtaiAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *choucangBtn;
- (IBAction)shoucangAction:(id)sender;

typedef void(^selectSegmentBlock)(NSInteger);
@property (nonatomic,copy) selectSegmentBlock selectSegmentblock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoucangSegmentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dongtaiAndShouCangSegmentToBottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *zhinanBtn;
@property (weak, nonatomic) IBOutlet UIButton *shoucangdongtaiBtn;
@property (weak, nonatomic) IBOutlet UIButton *huatiBtn;
- (IBAction)shoucangSegmentAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *liaoTianBtn;

typedef void(^liaoTianBlock)();
@property (nonatomic,copy) liaoTianBlock liaoTianblock;

- (IBAction)liaoTianAction:(id)sender;


typedef void(^shoucangSegmentBlock)(NSInteger);
@property (nonatomic,copy) shoucangSegmentBlock shoucangSegmentblock;

@end

NS_ASSUME_NONNULL_END
