//
//  YXMineMyCollectionTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/5/29.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXMineMyCollectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UILabel *collLbl;
-(void)setCellData:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
