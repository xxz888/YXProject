//
//  YXHomeXueJiaViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/3.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "YXHomeXueJiaTableViewCell.h"
#import "YXHomeXueJiaHeaderView.h"
#import "YXHomeXueJiaPinPaiViewController.h"
#import "YXHomeXueJiaWenHuaViewController.h"
#import "YXHomeXueJiaToolsViewController.h"
#import "YXHomeXueJiaQuestionViewController.h"
#import "YXHomeXueJiaPeiJianViewController.h"
@interface YXHomeXueJiaViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIView *bootomView;
@property(nonatomic,strong)UITableView * bottomTableView;
@property(nonatomic,strong)YXHomeXueJiaHeaderView * headerView;
@property(nonatomic,strong)NSMutableArray * informationArray;
@property(nonatomic,strong)NSMutableArray * scrollImgArray;
@property (nonatomic,strong) NSMutableArray * vcArr;


@end
