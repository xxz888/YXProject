//
//  RichTextViewController.h
//  RichTextView
//
//  Created by     songguolin on 16/1/7.
//  Copyright © 2016年 innos-campus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RichTextViewControllerDelegate <NSObject>
//2.block传值  typedef void(^returnBlock)();
typedef void(^dismissBlock) ();
//block
@optional
-(void)uploadImageArray:(NSArray *)imageArr withCompletion:(NSString * (^)(NSArray * urlArray))completion;

@end



typedef void (^inputFinished)(NSArray *  content,NSArray * imageArr);
typedef NSArray *(^uploadCompelte)(void);

IB_DESIGNABLE
@interface RichTextViewController : UIViewController

@property (weak,nonatomic) id<RichTextViewControllerDelegate>RTDelegate;

@property (weak, nonatomic) IBOutlet UIButton *fontBtn;
@property (weak, nonatomic) IBOutlet UIButton *colorBtn;
@property (weak, nonatomic) IBOutlet UIButton *boldBtn;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;


//提示字
@property (nonatomic,copy) IBInspectable NSString * placeholderText;
//是否返回的是网页，是的话请实现 代理方法
@property (nonatomic,assign) BOOL feedbackHtml;
//这一种是返回
@property (nonatomic,copy) inputFinished finished;

//初始化页面
+(instancetype)ViewController;
//
////编辑富文本，设置内容
//-(void)setContent:(NSArray *)content;
@property (nonatomic,strong) NSArray * content;






//block声明属性
@property (nonatomic, copy) dismissBlock mDismissBlock;
//block声明方法
-(void)toDissmissSelf:(dismissBlock)block;



@property (weak, nonatomic) IBOutlet UIButton *closeView;
- (IBAction)coseViewAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleTf;

@property (weak, nonatomic) IBOutlet UIButton *paizhaoBtn;
- (IBAction)paizhaoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextAction:(id)sender;

@end
