//
//  YXPublishImageTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/5.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LTTextView.h"
#import "QMUITextView.h"

NS_ASSUME_NONNULL_BEGIN



@interface YXPublishImageTableViewCell : BaseTableViewCell
typedef void(^tagStringBlock)(NSString *);
typedef void(^locationBlock)(YXPublishImageTableViewCell *);
typedef void(^moreBlock)(void);

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (weak, nonatomic) IBOutlet UIView *floatView;
@property (weak, nonatomic) IBOutlet UIView *ttView;
@property (weak, nonatomic) IBOutlet UIButton *xinhuatiBtn;
- (IBAction)xinhuatiAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
- (IBAction)moreAction:(id)sender;
@property (nonatomic,copy) tagStringBlock block;
@property (nonatomic,copy) locationBlock locationblock;
@property (nonatomic,copy) moreBlock moreBlock;
@property(nonatomic, strong) QMUITextView * qmuiTextView;
@end

NS_ASSUME_NONNULL_END
