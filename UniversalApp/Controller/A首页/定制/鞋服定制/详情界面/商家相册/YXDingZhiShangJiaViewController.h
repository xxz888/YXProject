//
//  YXDingZhiShangJiaViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2020/2/7.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import "RootViewController.h"
typedef void(^ClickCollectionItemBlock)(NSString *);

NS_ASSUME_NONNULL_BEGIN

@interface YXDingZhiShangJiaViewController : RootViewController
@property (weak, nonatomic) IBOutlet UICollectionView *yxCollectionView;
- (IBAction)backVcAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
- (IBAction)btnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottom1;
@property (weak, nonatomic) IBOutlet UIView *bottom2;
@property (nonatomic,copy) ClickCollectionItemBlock clickCollectionItemBlock;
@property (strong, nonatomic) NSArray * startArray;

@end

NS_ASSUME_NONNULL_END
