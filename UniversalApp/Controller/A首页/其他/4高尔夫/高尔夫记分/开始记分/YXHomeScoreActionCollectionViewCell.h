//
//  YXHomeScoreActionCollectionViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeScoreActionCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *biaozhunGanLbl;
@property(nonatomic, strong, readonly) UILabel *contentLabel;
@property(nonatomic, assign) BOOL debug;
@property(nonatomic, assign) CGFloat pagingThreshold;
@property(nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@property (weak, nonatomic) IBOutlet UIButton *subBenGanBtn;
@property (weak, nonatomic) IBOutlet UIButton *subTuiGanBtn;

@property (weak, nonatomic) IBOutlet UIView *xtwView;
@property (weak, nonatomic) IBOutlet UIView *lyqView;
@property (weak, nonatomic) IBOutlet UIView *xnqView;
@property (weak, nonatomic) IBOutlet UIView *bzgView;
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIView *sbjView;


@property (weak, nonatomic) IBOutlet UILabel *benGanLbl;
@property (weak, nonatomic) IBOutlet UILabel *TuiGanLbl;


- (IBAction)benGanAddAction:(id)sender;
- (IBAction)benGanSubAction:(id)sender;
- (IBAction)tuiGanAddAction:(id)sender;
- (IBAction)tuiGanSubAction:(id)sender;


@property (nonatomic,assign) NSInteger totalBiaoZhunGan;
@property (nonatomic,assign) NSInteger benGanValue;
@property (nonatomic,assign) NSInteger tuiGanValue;


@property (weak, nonatomic) IBOutlet UILabel *rightBigGanLbl;
@property (weak, nonatomic) IBOutlet UILabel *rightSmaillGanLbl;


@end

NS_ASSUME_NONNULL_END
