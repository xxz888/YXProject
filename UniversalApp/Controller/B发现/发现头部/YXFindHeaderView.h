//
//  YXFindHeaderView.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/7/19.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^searchBlock)();
typedef void(^fabuBlock)();

@interface YXFindHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *segView;
- (IBAction)searchAction:(id)sender;
- (IBAction)fabuAction:(id)sender;
@property (nonatomic,copy) searchBlock searchBlock;
@property (nonatomic,copy) fabuBlock fabuBlock;

@end

NS_ASSUME_NONNULL_END
