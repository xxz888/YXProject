//
//  YXZhiNan3Cell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/27.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXZhiNan3Cell : UITableViewCell
    //180
-(void)setCellData:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoHeight;
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;

@end

NS_ASSUME_NONNULL_END
