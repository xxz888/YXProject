//
//  YXDingZhiDetailView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/13.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXMapNavigationView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^PingLunBlock)(void);
typedef void(^ClickCountViewBlock)(void);

@interface YXDingZhiDetailView : UIView
- (IBAction)pinglunAction:(id)sender;
@property(nonatomic,copy)PingLunBlock pingLunBlock;
@property(nonatomic,copy)ClickCountViewBlock clickCountViewBlock;
@property (weak, nonatomic) IBOutlet UIImageView *cellImv;

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIView * starView;

@property (weak, nonatomic) IBOutlet UILabel *cellTime;
@property (weak, nonatomic) IBOutlet UILabel *cellAdress;
@property (weak, nonatomic) IBOutlet UILabel *cellFar;
@property (weak, nonatomic) IBOutlet UILabel *pingjiaCount;
@property (weak, nonatomic) IBOutlet UIView *cellAdressBottomView;
@property (nonatomic, strong)JXMapNavigationView *mapNavigationView;

@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;

@property (strong, nonatomic) NSDictionary * startDic;
-(void)setCellData;
@end

NS_ASSUME_NONNULL_END
