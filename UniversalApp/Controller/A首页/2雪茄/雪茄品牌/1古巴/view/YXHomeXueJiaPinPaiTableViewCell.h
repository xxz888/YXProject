//
//  YXHomeXueJiaPinPaiTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/7.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHomeXueJiaPinPaiTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellLbl;
@property (nonatomic,strong) NSString * id;

@end

NS_ASSUME_NONNULL_END
