//
//  YXPublishNewTagView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/11/7.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^fabuBlock)();
typedef void(^makeSureBlock)();
typedef void(^closeBlock)();

@interface YXPublishNewTagView : UIView
- (IBAction)closeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *huatiTf;
@property (weak, nonatomic) IBOutlet UIButton *fabuBtn;
- (IBAction)fabuAction:(id)sender;
- (IBAction)makeSureAction:(id)sender;

@property(nonatomic,copy)fabuBlock fabublock;
@property(nonatomic,copy)makeSureBlock makeSureblock;
@property(nonatomic,copy)closeBlock closeblock;


@end

NS_ASSUME_NONNULL_END
