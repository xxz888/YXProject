//
//  YXFirstFindImageTableViewCell.h
//  UniversalApp
//
//  Created by 小小醉 on 2019/6/12.
//  Copyright © 2019 徐阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IXAttributeTapLabel.h"
NS_ASSUME_NONNULL_BEGIN
@interface YXFirstFindImageTableViewCell : UITableViewCell
@property (nonatomic,assign) NSInteger tagId;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet IXAttributeTapLabel *detailLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeight;
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midViewHeight;
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic;
-(void)setCellValue:(NSDictionary *)dic;
@property (nonatomic,strong) NSMutableDictionary * dataDic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenter;
-(CGFloat)getTitleTagLblHeight:(NSDictionary *)dic;

@property (weak, nonatomic) IBOutlet UIImageView *imgV2;
@property (weak, nonatomic) IBOutlet UIImageView *imgV3;
@property (weak, nonatomic) IBOutlet UIImageView *imgV4;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIImageView *onlyOneImv;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;

//点击头像
typedef void(^Click1ImageBlock)(NSInteger);
@property (nonatomic,copy) Click1ImageBlock clickImageBlock;
@property (weak, nonatomic) IBOutlet UIImageView *imgV1;
//分享
typedef void(^Click1ShareBlock)(YXFirstFindImageTableViewCell *);
- (IBAction)shareAction:(id)sender;
@property (nonatomic,copy) Click1ShareBlock shareblock;



typedef void(^ClickTag1Block)(NSString *);
@property (nonatomic,copy) ClickTag1Block clickTagblock;
    
    
    
@property (weak, nonatomic) IBOutlet UILabel *zanCount;
@property (weak, nonatomic) IBOutlet UILabel *talkCount;
    
- (IBAction)zanTalkAction:(id)sender;
    
    
typedef void(^clickInDetail)(NSInteger,YXFirstFindImageTableViewCell *cell);
@property (nonatomic,copy) clickInDetail clickDetailblock;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
    @property (weak, nonatomic) IBOutlet UIView *midLunBoView;
    
    
- (void)setUpSycleScrollView:(NSArray *)photoArray height:(CGFloat)height;
@property(nonatomic)SDCycleScrollView *cycleScrollView3;
@property (nonatomic)NSInteger tatolCount;
@property (weak, nonatomic) IBOutlet UILabel *rightCountLbl;

@end

NS_ASSUME_NONNULL_END
