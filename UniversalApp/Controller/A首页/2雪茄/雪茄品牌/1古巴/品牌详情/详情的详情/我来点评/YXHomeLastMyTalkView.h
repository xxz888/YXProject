//
//  YXHomeLastMyTalkView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/10.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^dismissBlock1)(void);
typedef void(^selectOption)(NSString *);
@interface YXHomeLastMyTalkView : UIView
@property (weak, nonatomic) IBOutlet UIView *waiguanView;
@property (weak, nonatomic) IBOutlet UIView *xiangweiView;
@property (weak, nonatomic) IBOutlet UIView *ranshaoView;
@property (weak, nonatomic) IBOutlet UIView *kouganView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property(nonatomic, strong) QMUITextView * qmuiTextView;
- (IBAction)fabiaoAction:(id)sender;
@property(nonatomic,strong)NSMutableDictionary * parDic;
@property (nonatomic,copy) dismissBlock1 block;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;


- (IBAction)btnAction:(id)sender;

@property (nonatomic,strong) NSString *recommend;

@property (nonatomic,copy) selectOption selectBlock;




@end

NS_ASSUME_NONNULL_END
