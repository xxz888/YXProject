//
//  YXHomeChiCunViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/11.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeChiCunViewController.h"

@interface YXHomeChiCunViewController ()
@property (weak, nonatomic) IBOutlet UILabel *daxiaoLbl;
@property (weak, nonatomic) IBOutlet UIView *yuanView;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property(nonatomic)UIBezierPath *path;

@end

@implementation YXHomeChiCunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.daxiaoLbl.text = @"50";
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat left = 80;
    CGFloat width = self.view.width - left*2;
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.sliderView.frame.size.width, self.sliderView.frame.size.height)];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    [self.sliderView addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    
    CGFloat pro = 0.5;
    slider.value = pro;
    
    [self huayuan:50];

}
// slider变动时改变label值
- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    CGFloat pro = slider.value;
    self.daxiaoLbl.text = [NSString stringWithFormat:@"%d",(int)(pro * 100)];
    [self huayuan:(int)(pro * 100)];
}
-(void)huayuan:(CGFloat)cornerRadius{
    [self.yuanView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    CAShapeLayer *layer = [CAShapeLayer new];
    //圆环的宽度
    layer.lineWidth = 1;
    //圆环的颜色
    layer.strokeColor = [UIColor darkGrayColor].CGColor;
    //背景填充色
    layer.fillColor = [UIColor clearColor].CGColor;
    //设置半径
    CGFloat radius = cornerRadius;
    //按照顺时针方向
    BOOL clockWise = true;
    //初始化一个路径
    self.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.yuanView.frame.size.width/2, self.yuanView.frame.size.height/2) radius:radius startAngle:(0) endAngle:2*M_PI clockwise:clockWise];
 
    layer.path = [self.path CGPath];
    [self.yuanView.layer addSublayer:layer];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
