//
//  YXZhiNan4Cell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXZhiNan4Cell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UIView *lunboView;
    //180
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lunboHeight;
-(void)setCellData:(NSDictionary *)dic;
    @end

NS_ASSUME_NONNULL_END
