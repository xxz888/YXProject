//
//  YXPublishImageTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/5.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "TableViewCell.h"
#import "LTTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXPublishImageTableViewCell : TableViewCell
@property (weak, nonatomic) IBOutlet UIView *ttView;
@property(nonatomic) LTTextView  *textView;
@end

NS_ASSUME_NONNULL_END
