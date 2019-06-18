//
//  YXWenZhangView.h
//  RichTextEditorDemo
//
//  Created by 小小醉 on 2019/6/5.
//  Copyright © 2019 Junior. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickTitleImgVBlock)(UIImageView *);
@interface YXWenZhangView : UIView

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImgV;
@property (nonatomic,copy) ClickTitleImgVBlock clickTitleImgBlock;
@end

NS_ASSUME_NONNULL_END
