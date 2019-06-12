//
//  YXWenZhangView.h
//  RichTextEditorDemo
//
//  Created by 小小醉 on 2019/6/5.
//  Copyright © 2019 Junior. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BackVCBlock)(void);
@interface YXWenZhangView : UIView

- (IBAction)backVC:(id)sender;
@property (nonatomic,copy) BackVCBlock backVCBlock;
@end

NS_ASSUME_NONNULL_END
