//
//  YXHomeScoreActionCollectionViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeScoreActionCollectionViewCell.h"

#define xinTianWeng_COLOR YXRGBAColor(254, 194, 84)
#define laoYing_COLOR YXRGBAColor(251, 24, 39)
#define xiaoNiao_COLOR YXRGBAColor(82, 182, 240)
#define biaoZhun_COLOR YXRGBAColor(83, 83, 83)
#define boji_COLOR YXRGBAColor(87, 196, 135)
#define sboji_COLOR YXRGBAColor(134, 71, 254)


@interface YXHomeScoreActionCollectionViewCell ()
@property(nonatomic, strong) CALayer *prevLayer;
@property(nonatomic, strong) CALayer *nextLayer;
@end
@implementation YXHomeScoreActionCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3;
        
        _contentLabel = [[UILabel alloc] qmui_initWithFont:UIFontLightMake(100) textColor:UIColorWhite];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.contentLabel];
        _contentLabel.hidden = YES;
        self.prevLayer = [CALayer layer];
        [self.prevLayer qmui_removeDefaultAnimations];
        self.prevLayer.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, .3).CGColor;
        [self.contentView.layer addSublayer:self.prevLayer];
        
        self.nextLayer = [CALayer layer];
        [self.nextLayer qmui_removeDefaultAnimations];
        self.nextLayer.backgroundColor = self.prevLayer.backgroundColor;
        [self.contentView.layer addSublayer:self.nextLayer];
        
    }
    return self;
}

- (void)setDebug:(BOOL)debug {
    _debug = debug;
    self.prevLayer.hidden = !debug;
    self.nextLayer.hidden = !debug;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.xtwView.backgroundColor = xinTianWeng_COLOR;
    self.lyqView.backgroundColor = laoYing_COLOR;
    self.xnqView.backgroundColor = xiaoNiao_COLOR;
    self.bzgView.backgroundColor = biaoZhun_COLOR;
    self.bjView.backgroundColor = boji_COLOR;
    self.sbjView.backgroundColor = sboji_COLOR;
    
    [self defaultColor:self.benGanLbl];

    self.totalBiaoZhunGan = [self.biaozhunGanLbl.text integerValue];
//    [self.contentLabel sizeToFit];
//    self.contentLabel.center = CGPointMake(CGRectGetWidth(self.contentView.bounds) / 2, CGRectGetHeight(self.contentView.bounds) / 2);
    
//    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
//        self.prevLayer.frame = CGRectMake(0, CGRectGetHeight(self.contentView.bounds) * (1 - self.pagingThreshold), CGRectGetWidth(self.contentView.bounds), PixelOne);
//        self.nextLayer.frame = CGRectSetY(self.prevLayer.frame, CGRectGetHeight(self.contentView.bounds) * self.pagingThreshold);
//    } else {
//        self.prevLayer.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) * (1 - self.pagingThreshold), 0, PixelOne, CGRectGetHeight(self.contentView.bounds));
//        self.nextLayer.frame = CGRectSetX(self.prevLayer.frame, CGRectGetWidth(self.contentView.bounds) * self.pagingThreshold);
//    }
}

#pragma mark ========== 本洞杆数加 ==========
- (IBAction)benGanAddAction:(id)sender {
    [self defaultColor:self.benGanLbl];
    [self colLblValue:self.benGanLbl btn:nil subOrAdd:YES];
}
#pragma mark ========== 本洞杆数减 ==========
- (IBAction)benGanSubAction:(id)sender {
    [self defaultColor:self.benGanLbl];
    [self colLblValue:self.benGanLbl btn:self.subBenGanBtn subOrAdd:NO];
}
 #pragma mark ========== 推杆加 ==========
- (IBAction)tuiGanAddAction:(id)sender {
    [self colLblValue:self.TuiGanLbl btn:nil subOrAdd:YES];
}
#pragma mark ========== 推杆减 ==========
- (IBAction)tuiGanSubAction:(id)sender {
    [self colLblValue:self.TuiGanLbl btn:self.subTuiGanBtn subOrAdd:NO];
}
//sOrA yes为加  no为减
-(void)colLblValue:(UILabel *)lbl btn:(UIButton *)btn subOrAdd:(BOOL)sOrA{
    NSInteger value = [lbl.text integerValue];
    if (sOrA) {
        value += 1;
        
    }else{
        //检查是否为1
        if (![self checkSubCountAction:lbl btn:btn]) {
            return;
        }
        value -=1;
    }
    lbl.text = NSIntegerToNSString(value);
    [self colChangeAllColor];
    self.rightBigGanLbl.text = self.benGanLbl.text;
    self.rightSmaillGanLbl.text = self.TuiGanLbl.text;
}
-(void)colChangeAllColor{
    NSInteger bendongCount = [self.benGanLbl.text integerValue];
    NSInteger tuiganCount = [self.TuiGanLbl.text integerValue];
        NSInteger colorCount = _totalBiaoZhunGan - (bendongCount + tuiganCount);
        UIColor  * currentColor;
        switch (colorCount) {
            case 0:
                currentColor = biaoZhun_COLOR;
                break;
            case 1:
                currentColor = xiaoNiao_COLOR;
                break;
            case 2:
                currentColor = laoYing_COLOR;
                break;
            case 3:
                currentColor = xinTianWeng_COLOR;
                break;
            case 4:
                currentColor = YXRGBAColor(204, 204, 204);
                break;
            case -1:
                currentColor = boji_COLOR;
                break;
            case -2:
                currentColor = sboji_COLOR;
                break;
            default:
                currentColor = YXRGBAColor(204, 204, 204);
                break;
        }
    self.benGanLbl.backgroundColor = currentColor;
}
-(BOOL)checkSubCountAction:(UILabel *)lbl btn:(UIButton *)btn{
    return btn.userInteractionEnabled = [lbl.text integerValue] != 0;
}
-(void)defaultColor:(UILabel *)lbl{
    if ([lbl.text integerValue] == 0) {
        lbl.textColor = KDarkGaryColor;
        lbl.backgroundColor = KWhiteColor;
    }else{
        lbl.textColor = KWhiteColor;
    }
}
@end
