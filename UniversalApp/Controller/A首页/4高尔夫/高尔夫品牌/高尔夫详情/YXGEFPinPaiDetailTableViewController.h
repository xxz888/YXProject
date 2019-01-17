//
//  YXGEFPinPaiDetailTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/17.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXGEFPinPaiDetailTableViewController : UITableViewController
@property(nonatomic,strong)NSMutableDictionary * dicData;
@property(nonatomic,strong)NSMutableDictionary * dicStartData;

@property (weak, nonatomic) IBOutlet UIImageView *section1ImageView;
@property (weak, nonatomic) IBOutlet UILabel *section1TitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *section1countLbl;
@property (weak, nonatomic) IBOutlet UIButton *section1GuanZhuBtn;
- (IBAction)section1GuanZhuAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *section1TextView;


@end

NS_ASSUME_NONNULL_END
