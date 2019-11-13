//
//  YXWenZhangEditorViewController.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/10/22.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^closeNewVcBlock)(void);

@interface YXWenZhangEditorViewController : RootViewController
@property(nonatomic,copy)closeNewVcBlock  closeNewVcblock;
@property (weak, nonatomic) IBOutlet UIButton *cuncaogaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *fabuBtn;

@end

NS_ASSUME_NONNULL_END
