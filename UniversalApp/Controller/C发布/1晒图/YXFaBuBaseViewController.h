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
#import "YXShaiTuModel.h"
#define photo1_BOOL photo1 && photo1.length > 5
#define photo2_BOOL photo2 && photo2.length > 5
#define photo3_BOOL photo3 && photo3.length > 5
#import "JQFMDB.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^dismissBlock) ();
typedef void(^closeNewVcBlock)(void);

@interface YXFaBuBaseViewController : RootViewController
@property (nonatomic,assign) BOOL whereComeCaogao;//yes是草稿进来
@property (nonatomic, strong) NSString * videoCoverImageString;
@property (nonatomic, assign) BOOL fabuType;//NO晒图图片YES晒图视频
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeight;
@property (weak, nonatomic) IBOutlet UIView *threeImageView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *xinhuatiBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property(nonatomic,strong)NSString * whereCome;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *faBuBtn;
@property (weak, nonatomic) IBOutlet UIButton *cunCaoGaoBtn;
- (IBAction)locationBtnAction:(id)sender;
- (IBAction)xinhuatiAction:(id)sender;
- (IBAction)moreAction:(id)sender;
- (IBAction)fabuAction:(id)sender;
@property (nonatomic,strong) NSMutableArray * photoImageList;
@property (nonatomic,strong) NSMutableArray * selectedPhotos;
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
@property (nonatomic,strong) NSString * photo1;
@property (nonatomic,strong) NSString * photo2;
@property (nonatomic,strong) NSString * photo3;
- (IBAction)closeViewAction:(id)sender;
-(void)closeViewAAA;
-(void)addNewTags;
@property(nonatomic,strong)YXShaiTuModel * model;
@property(nonatomic,strong)NSMutableDictionary * startDic;
@property(nonatomic,copy)closeNewVcBlock  closeNewVcblock;
@property (weak, nonatomic) IBOutlet UIButton *fabuBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewTopHeight;

@end

NS_ASSUME_NONNULL_END
