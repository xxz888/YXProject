//
//  YXFaBuBaseViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/2/22.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "RootViewController.h"
#import "QMUITextView.h"
#import "LLImagePickerView.h"
#import "CBGroupAndStreamView.h"
#import "YXGaoDeMapViewController.h"
#import "YXPublishMoreTagsViewController.h"
#import "QiniuLoad.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^dismissBlock) ();

@interface YXFaBuBaseViewController : RootViewController
@property (nonatomic,assign) BOOL whereComeCaogao;//yes是草稿进来

@property (weak, nonatomic) IBOutlet UITextField *titleTf;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTfHeight;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeight;

@property (weak, nonatomic) IBOutlet UIView *threeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeImageViewHeight;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Height;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Height;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3Height;


@property (weak, nonatomic) IBOutlet UIButton *xinhuatiBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property(nonatomic,strong)NSString * whereCome;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (weak, nonatomic) IBOutlet UIButton *faBuBtn;
@property (weak, nonatomic) IBOutlet UIButton *cunCaoGaoBtn;
- (IBAction)locationBtnAction:(id)sender;
- (IBAction)xinhuatiAction:(id)sender;
- (IBAction)moreAction:(id)sender;
- (IBAction)fabuAction:(id)sender;

@property (nonatomic,strong) NSMutableArray * photoImageList;
@property(nonatomic, strong) QMUITextView * qmuiTextView;
@property (strong, nonatomic) CBGroupAndStreamView * menueView;
@property (weak, nonatomic) IBOutlet UIView *floatView;

@property (nonatomic,strong)  NSString * textViewInput;
@property (nonatomic,strong)  NSString * locationString;
@property (nonatomic,strong) NSMutableArray * tagArray;
- (IBAction)closeViewAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fabuHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *caogaoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeHeight;

@property (weak, nonatomic) IBOutlet UIButton *closeView;
@property(nonatomic)QMUITextField * xinhuatiTf;

@property (weak, nonatomic) IBOutlet UILabel *faxianLbl;
@property (weak, nonatomic) IBOutlet UIImageView *fengcheView;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *floatHeight_Tag;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;

@property (weak, nonatomic) IBOutlet UIButton *del1;
@property (weak, nonatomic) IBOutlet UIButton *del2;
@property (weak, nonatomic) IBOutlet UIButton *del3;


@property (nonatomic,strong) NSString * photo1;
@property (nonatomic,strong) NSString * photo2;
@property (nonatomic,strong) NSString * photo3;

- (IBAction)delAction:(id)sender;
- (IBAction)closeViewAction:(id)sender;
-(void)closeViewAAA;
-(void)addNewTags;
@end

NS_ASSUME_NONNULL_END
