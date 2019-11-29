//
//  BaseAlertController.m
//  
//
//  Created by 小小醉 on 2019/11/29.
//

#import "BaseAlertController.h"
@interface BaseAlertController ()

@property (nonatomic,strong) UITapGestureRecognizer *closeGesture;

@end

@implementation BaseAlertController

- (void)viewDidLoad {

    [super viewDidLoad];

    // Do any additional setup after loading the view.

    self.closeGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAlert:)];

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    UIView*superView =self.view.superview;

    if(![superView.gestureRecognizers containsObject:self.closeGesture]) {

        [superView.subviews[0]addGestureRecognizer:self.closeGesture];

        superView.subviews[0].userInteractionEnabled = YES;

    }

}

- (void)closeAlert:(UITapGestureRecognizer*) gesture{

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.

}

@end
