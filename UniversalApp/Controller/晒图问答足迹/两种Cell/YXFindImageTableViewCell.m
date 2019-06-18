//
//  YXFindImageTableViewCell.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/28.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXFindImageTableViewCell.h"
#import "XHWebImageAutoSize.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "UIImage+ImgSize.h"
#import "ImageScale.h"

@interface YXFindImageTableViewCell()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) ImageScale *imageScale;

@end
@implementation YXFindImageTableViewCell
+(CGFloat)cellNewDetailNeedHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    
    
//    CGSize size = [UIImage getImageSizeWithURL:dic[@"url_list"][0]];
//    double scale = 0;
//    if (size.width == 0) {
//        scale = 0;
//    }else{
//        scale = size.height/size.width;
//    }
//    
    
    
    CGFloat imageHeight =  (KScreenWidth-10);
    NSString * titleText = [NSString stringWithFormat:@"%@%@", dic[@"detail"],dic[@"tag"]];
    //内容
    CGFloat height_size = [ShareManager inTextOutHeight:[titleText UnicodeToUtf8] lineSpace:9 fontSize:14];
    CGFloat lastHeight =
    height_size +
    imageHeight;
    return lastHeight + 150 ;
}


-(CGFloat)getTitleTagLblHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
     NSString * titleText = [NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"tag"]];
    return [ShareManager inTextOutHeight:[titleText UnicodeToUtf8] lineSpace:9 fontSize:14];
}
-(CGFloat)getTitleTagtextViewHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    return whereCome ? 30 : 0;
}
-(CGFloat)getImvHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    NSString * url =  whereCome ? dic[@"pic1"]:dic[@"photo1"];
    if (url.length < 5) {
        return 0;
    }
    return   [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:400];
}
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    return 0 ;
}

-(CGFloat)getImageViewSize:(NSString *)imgUrl{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    UIImage *showimage = [UIImage imageWithData:data];
    CGFloat scale = showimage.size.height/showimage.size.width;
    return KScreenWidth * scale;
}
- (IBAction)searchAllPlBtnAction:(id)sender{
    self.jumpDetailVCBlock(self);
}
//添加轮播图
- (void)setUpSycleScrollView:(NSArray *)photoArray height:(CGFloat)height{
    [_cycleScrollView3 removeFromSuperview];
    _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 200) shouldInfiniteLoop:NO imageNamesGroup:@[]];
    _cycleScrollView3.delegate = self;
    [self.lunBoView addSubview:_cycleScrollView3];
    
    self.rightCountLbl.hidden = height == 0 ;
    
    _tatolCount = photoArray.count;

 
    _cycleScrollView3.frame = CGRectMake(0, 0, kScreenWidth, height-10);
    
    _cycleScrollView3.delegate = self;
    _cycleScrollView3.bannerImageViewContentMode = 1;
    _cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
    _cycleScrollView3.currentPageDotColor =  SEGMENT_COLOR;
    _cycleScrollView3.showPageControl = YES;
    _cycleScrollView3.autoScrollTimeInterval = 10000;
    _cycleScrollView3.pageDotColor = YXRGBAColor(239, 239, 239);
    _cycleScrollView3.backgroundColor = KWhiteColor;
    
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index imageView:(UIImageView *)imageView{
    self.imageScale= [ImageScale new];
    [self.imageScale scaleImageView:imageView];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.rightCountLbl.text = [NSString stringWithFormat:@"%ld/%ld",index+1,_tatolCount];
 
}
-(void)setCellValue:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    [self cellValueDic:dic searchBtn:self.searchBtn pl1NameLbl:self.pl1NameLbl pl2NameLbl:self.pl2NameLbl pl1ContentLbl:self.pl1ContentLbl pl2ContentLbl:self.pl2ContentLbl titleImageView:self.titleImageView addPlImageView:self.addPlImageView talkCount:self.talkCount titleLbl:self.titleLbl timeLbl:self.timeLbl mapBtn:self.mapBtn likeBtn:self.likeBtn zanCount:self.zanCount plLbl:self.plLbl];
    
    NSArray * imgArray = [dic[@"photo_list"] split:@","];
    if (imgArray.count > 0) {
        self.conViewHeight.constant = [self getImvHeight:dic whereCome:whereCome];
        [self setUpSycleScrollView:imgArray height:KScreenWidth-20];
        _cycleScrollView3.hidden = NO;

    }else{
        self.conViewHeight.constant = 0;
        _cycleScrollView3.hidden = YES;
    }

    _rightCountLbl.text = [NSString stringWithFormat:@"%@/%ld",@"1",imgArray.count];
    _rightCountLbl.hidden = [_rightCountLbl.text isEqualToString:@"1/1"] ||
    [_rightCountLbl.text isEqualToString:@"1/0"];
    

    //图片高度
    self.imvHeight.constant = [self getImvHeight:dic whereCome:whereCome];

    
    //title
    NSString * titleText = [[NSString stringWithFormat:@"%@%@",dic[@"detail"],dic[@"tag"]] UnicodeToUtf8];
    self.titleTagLbl.text = titleText;
    
    kWeakSelf(self);

    NSArray * indexArray = [dic[@"tag"] split:@" "];
    NSMutableArray * modelArray = [NSMutableArray array];
    for (NSString * string in indexArray) {
        //设置需要点击的字符串，并配置此字符串的样式及位置
        IXAttributeModel    * model = [IXAttributeModel new];
        model.range = [titleText rangeOfString:string];
        model.string = string;
        model.attributeDic = @{NSForegroundColorAttributeName : [UIColor blueColor]};
        [modelArray addObject:model];
    }
    //文本点击回调
    self.titleTagLbl.tapBlock = ^(NSString *string) {
        NSLog(@" -- %@ --",string);
        weakself.clickTagblock(string);
    };
    //label内容赋值
    [self.titleTagLbl setText:titleText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
               tapStringArray:modelArray];
    self.titleTagLblHeight.constant = [self getTitleTagLblHeight:dic whereCome:whereCome];

    [ShareManager setLineSpace:9 withText:self.titleTagLbl.text inLabel:self.titleTagLbl tag:dic[@"tag"]];

    //全部评论
    if ([dic[@"publish_site"] isEqualToString:@""] || !dic[@"publish_site"] ) {
        self.nameCenter.constant = self.titleImageView.frame.origin.y;
    }else{
        self.nameCenter.constant = 0;
    }
}
- (void)messageAction:(UILabel *)theLab changeString:(NSString *)change andMarkFondSize:(float)fontSize {
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    
    
    NSString *string1=tempStr;
    NSString *string2=change;
    
    NSArray *array=[string1 componentsSeparatedByString:string2];
    NSMutableArray *arrayOfLocation=[NSMutableArray new];
    int d=0;
    for (int i=0; i<array.count-1; i++) {
        NSString *string=array[i];
        NSNumber *number=[NSNumber numberWithInt:d+=string.length];
        d+=string2.length;
        [arrayOfLocation addObject:number];
    }
    for (int i=0; i<arrayOfLocation.count; i++) {
        NSRange  markRange  = NSMakeRange([arrayOfLocation[i] integerValue], change.length);
        [strAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiTC-Medium" size:fontSize] range:markRange];
        theLab.attributedText = strAtt;
    }
    
}
- (IBAction)likeBtnAction:(id)sender {
    if (![userManager loadUserInfo]) {
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    self.zanblock(self);
}
- (IBAction)shareAction:(id)sender {
    self.shareblock(self);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleImageView.layer.masksToBounds = YES;
    self.titleImageView.layer.cornerRadius = self.titleImageView.frame.size.width / 2.0;
    self.addPlImageView.layer.masksToBounds = YES;
    self.addPlImageView.layer.cornerRadius = self.addPlImageView.frame.size.width / 2.0;
    
    
    

    
    ViewRadius(self.midImageView, 3);
    //图片这种类型的view默认是没有点击事件的，所以要把用户交互的属性打开
    self.titleImageView.userInteractionEnabled = YES;
    //添加点击手势
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    //点击几次后触发事件响应，默认为：1
    click.numberOfTapsRequired = 1;
    [self.titleImageView addGestureRecognizer:click];
    
    self.rightCountLbl.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];
    self.rightCountLbl.textColor = KWhiteColor;
    ViewRadius(self.rightCountLbl, 10);
    
    

}
-(void)clickAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    self.clickImageBlock(tag);
}


- (IBAction)addPlAction:(id)sender {
    self.addPlActionblock(self);
}




@end
