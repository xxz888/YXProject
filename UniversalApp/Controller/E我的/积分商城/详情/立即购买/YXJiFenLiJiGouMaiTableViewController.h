//
//  YXJiFenLiJiGouMaiTableViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/10.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXJiFenLiJiGouMaiTableViewController : RootTableViewController
- (IBAction)backVcAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *shouhuoren;
@property (weak, nonatomic) IBOutlet UILabel *shouhuoPhone;
@property (weak, nonatomic) IBOutlet UILabel *shouhuoAddress;

@property (weak, nonatomic) IBOutlet UIImageView *shangpinimg;
@property (weak, nonatomic) IBOutlet UILabel *shangpinname;
@property (weak, nonatomic) IBOutlet UILabel *shangpincolor;
@property (weak, nonatomic) IBOutlet UILabel *shangpinjifen;
@property (weak, nonatomic) IBOutlet UILabel *shangpinAlljifen;
@property (weak, nonatomic) IBOutlet UILabel *keyongjifen;
- (IBAction)querenzhifuAction:(id)sender;
@property (nonatomic,strong) NSMutableDictionary * startDic;
@property (weak, nonatomic) IBOutlet UILabel *jifenbugoulbl;


@end

NS_ASSUME_NONNULL_END
