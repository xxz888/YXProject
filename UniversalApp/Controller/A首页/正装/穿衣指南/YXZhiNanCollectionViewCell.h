//
//  YXZhiNanCollectionViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/17.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXZhiNanCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *collImageView;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *lockImv;

@end

NS_ASSUME_NONNULL_END
