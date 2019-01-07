//
//  YXHomeXueJiaHeaderView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ClickGridView <NSObject>
-(void)clickGridView:(NSInteger)tag;
@end

@interface YXHomeXueJiaHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property(nonatomic, strong) QMUIGridView *gridView;
- (void)setUpSycleScrollView:(NSMutableArray *)imageArray;
@property (nonatomic,weak) id<ClickGridView> delegate;

@end
