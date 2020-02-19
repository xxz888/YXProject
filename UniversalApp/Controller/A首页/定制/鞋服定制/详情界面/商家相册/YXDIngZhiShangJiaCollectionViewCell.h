//
//  YXDIngZhiShangJiaCollectionViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2020/2/7.
//  Copyright © 2020 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXDIngZhiShangJiaCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shangjiaImv;
@property (weak, nonatomic) IBOutlet UIButton *shangjiaPlayBtn;
- (IBAction)shangjiaPlayAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
