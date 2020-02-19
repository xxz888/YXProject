//
//  YXDingZhi1ViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/12/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXDingZhi1ViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
- (IBAction)addressAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
- (IBAction)sortAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)searchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *sortLbl;
@property (weak, nonatomic) IBOutlet UITableView *yxTableView;


@property (strong, nonatomic)NSString * lat;
@property (strong, nonatomic)NSString * lng;
@property (strong, nonatomic)NSString * sort;
@property (strong, nonatomic)NSString * obj;
@property (nonatomic,strong) NSString * currentCity;

@end

NS_ASSUME_NONNULL_END
