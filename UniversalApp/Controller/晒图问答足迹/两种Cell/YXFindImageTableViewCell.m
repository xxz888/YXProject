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
@interface YXFindImageTableViewCell()<SDCycleScrollViewDelegate>
@property(nonatomic)SDCycleScrollView *cycleScrollView3;
@property (nonatomic)NSInteger tatolCount;

@end
@implementation YXFindImageTableViewCell

-(CGFloat)getTitleTagLblHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
     NSString * titleText = [NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"index"]];
    return [ShareManager inTextOutHeight:[titleText UnicodeToUtf8]];
}
-(CGFloat)getTitleTagtextViewHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    return whereCome ? 30 : 0;
}
-(CGFloat)getImvHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    NSString * url =  whereCome ? dic[@"pic1"]:dic[@"photo1"];
    if (url.length < 5) {
        return 0;
    }
    return    [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:400];
}
+(CGFloat)cellDefaultHeight:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    NSArray * plArray;
    NSDictionary * max_hot_commentDic;
    if (whereCome) {
        plArray = dic[@"comment_list"];
    }else{
        max_hot_commentDic = dic[@"max_hot_comment"];
    }
    NSString * url = whereCome ? dic[@"pic1"]:dic[@"photo1"];
    CGFloat imageHeight = [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:400];
    if (url.length < 5) {
        imageHeight = 0;
    }
    NSString * titleText = [NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"index"]];
    
    //内容
    CGFloat height_size = [ShareManager inTextOutHeight:[titleText UnicodeToUtf8]];
    //评论高度
    //两条评论
    BOOL showPlAllLbl = NO;
    CGFloat plHeight = 0;
    NSString  * connectStr = @"";
    if (dic[@"plHeight"]) {
        plHeight = [dic[@"plHeight"] floatValue];
    }else{
        if (whereCome) {
            if (plArray && plArray.count>=1) {
                NSString * str1 = [[plArray[0][@"user_name"] UnicodeToUtf8] append:@":"];
                NSString * str2= [plArray[0][@"comment"] UnicodeToUtf8];
                if (plArray.count == 1) {
                    connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@",str1,str2]];
                }else{
                    connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@\n",str1,str2]];
                }
            }
            if (plArray && plArray.count>=2) {
                NSString * str1 = [[plArray[1][@"user_name"] UnicodeToUtf8] append:@":"];
                NSString * str2= [plArray[1][@"comment"] UnicodeToUtf8];
                connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@",str1,str2]];
            }
            if ([dic[@"comment_number"] integerValue] > plArray.count) {
                showPlAllLbl = YES;
            }
        }else{
            if (max_hot_commentDic) {
                NSString * str1 = [[max_hot_commentDic[@"user_name"] UnicodeToUtf8] append:@":"];
                NSString * str2= [max_hot_commentDic[@"comment"] UnicodeToUtf8];
                if ([[max_hot_commentDic allKeys] count] > 0) {
                    connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@",str1,str2]];
                    showPlAllLbl = YES;
                }
            }
        }
        plHeight = [ShareManager inTextOutHeight:connectStr];
    }
    
    CGFloat lastHeight =
    plHeight+
    (showPlAllLbl ? 25 : 0) +
    (whereCome ? 30 : 0) +
    height_size +
    imageHeight;
    return lastHeight + 170 ;
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
    self.rightCountLbl.hidden = height == 0 ;
    
    _tatolCount = photoArray.count;

 
    _cycleScrollView3.frame = CGRectMake(0, 0, kScreenWidth, height-10);
    
    _cycleScrollView3.delegate = self;
    _cycleScrollView3.bannerImageViewContentMode = 0;
    _cycleScrollView3.imageURLStringsGroup = [NSArray arrayWithArray:photoArray];
    _cycleScrollView3.currentPageDotColor = A_COlOR;
    _cycleScrollView3.showPageControl = YES;
    _cycleScrollView3.autoScrollTimeInterval = 10000;
    _cycleScrollView3.pageDotColor = YXRGBAColor(239, 239, 239);
    _cycleScrollView3.backgroundColor = KWhiteColor;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.rightCountLbl.text = [NSString stringWithFormat:@"%ld/%ld",index+1,_tatolCount];
}
-(void)setCellValue:(NSDictionary *)dic whereCome:(BOOL)whereCome{
    [self cellValueDic:dic searchBtn:self.searchBtn pl1NameLbl:self.pl1NameLbl pl2NameLbl:self.pl2NameLbl pl1ContentLbl:self.pl1ContentLbl pl2ContentLbl:self.pl2ContentLbl titleImageView:self.titleImageView addPlImageView:self.addPlImageView talkCount:self.talkCount titleLbl:self.titleLbl timeLbl:self.timeLbl mapBtn:self.mapBtn likeBtn:self.likeBtn zanCount:self.zanCount plLbl:self.plLbl];
    
    NSMutableArray * imgArray =  [NSMutableArray array];
    if ([dic[@"photo1"] length] > 5) {
        [imgArray addObject:dic[@"photo1"]];
    }
    if ([dic[@"photo2"] length] > 5) {
        [imgArray addObject:dic[@"photo2"]];
    }
    if ([dic[@"photo3"] length] > 5) {
        [imgArray addObject:dic[@"photo3"]];
    }
    if ([dic[@"pic1"] length] > 5) {
        [imgArray addObject:dic[@"pic1"]];
    }
    if ([dic[@"pic2"] length] > 5) {
        [imgArray addObject:dic[@"pic2"]];
    }
    if ([dic[@"pic3"] length] > 5) {
        [imgArray addObject:dic[@"pic3"]];
    }
    if (imgArray.count > 0) {
        self.conViewHeight.constant = [self getImvHeight:dic whereCome:whereCome];
        [self setUpSycleScrollView:imgArray height:[self getImvHeight:dic whereCome:whereCome]];
        _cycleScrollView3.hidden = NO;


    }else{
        self.conViewHeight.constant = 0;
        _cycleScrollView3.hidden = YES;
    }
    _rightCountLbl.text = [NSString stringWithFormat:@"%@/%ld",@"1",imgArray.count];
    _rightCountLbl.hidden = [_rightCountLbl.text isEqualToString:@"1/1"] ||
    [_rightCountLbl.text isEqualToString:@"1/0"];
    
    
    //两条评论
    NSArray * commentArray;
    NSDictionary * max_hot_commentDic;
    NSString * connectStr = @"";
    NSString * comment_number = @"";
    BOOL showPlAllLbl = NO;
    if (dic[@"plContent"]) {
        connectStr = dic[@"plContent"];
    }else{
        if (dic[@"comment_list"]) {
            commentArray = dic[@"comment_list"];
            if (commentArray && commentArray.count>=1) {
                NSString * str1 = [[commentArray[0][@"user_name"] UnicodeToUtf8] append:@":"];
                NSString * str2= [commentArray[0][@"comment"] UnicodeToUtf8];
                if (commentArray.count == 1) {
                    connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@",str1,str2]];
                }else{
                    connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@\n",str1,str2]];
                }
            }
            
            if (commentArray && commentArray.count>=2) {
                NSString * str1 = [[commentArray[1][@"user_name"] UnicodeToUtf8] append:@":"];
                NSString * str2= [commentArray[1][@"comment"] UnicodeToUtf8];
                connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@",str1,str2]];
            }
            
            if ([dic[@"comment_number"] integerValue] > commentArray.count) {
                showPlAllLbl = YES;
            }
            comment_number = kGetString(dic[@"comment_number"]);
        }
        if (dic[@"max_hot_comment"]) {
            max_hot_commentDic = dic[@"max_hot_comment"];
            if ([max_hot_commentDic.allKeys count] > 0) {
                NSString * str1 = [[max_hot_commentDic[@"user_name"] UnicodeToUtf8] append:@":"];
                NSString * str2= [max_hot_commentDic[@"comment"] UnicodeToUtf8];
                connectStr = [connectStr append:[NSString stringWithFormat:@"%@%@",str1,str2]];
                showPlAllLbl = YES;
            }
            comment_number = kGetString(dic[@"comment_number"]);
        }
    }


    //查看所有多少评论
    self.plAllHeight.constant = showPlAllLbl ? 25 : 0;
    NSString * allPlCountString = [NSString stringWithFormat:@"查看全部%@评论",comment_number];
    allPlCountString = self.plAllHeight.constant == 0 ? @"" : allPlCountString;
    [self.searchBtn setTitle:allPlCountString forState:UIControlStateNormal];
  
    
    
    self.plLbl.text = connectStr;
    //评论高度
    self.pl1Height.constant =  [ShareManager inTextOutHeight:self.plLbl.text];
    if ([connectStr contains:@"\n"]) {
        [ShareManager setLineSpace:9 withText:self.plLbl.text inLabel:self.plLbl tag:dic[@"index"]];
    }

    
    
    //足迹的那一栏
    self.titleTagtextViewHeight.constant = [self getTitleTagtextViewHeight:dic whereCome:whereCome];


    
    //图片高度
    self.imvHeight.constant = [self getImvHeight:dic whereCome:whereCome];

    
    //title
    NSString * titleText = [[NSString stringWithFormat:@"%@%@",whereCome ? dic[@"content"]:dic[@"describe"],dic[@"index"]] UnicodeToUtf8];
    self.titleTagLbl.text = titleText;
   [ShareManager setLineSpace:9 withText:self.titleTagLbl.text inLabel:self.titleTagLbl tag:dic[@"index"]];
    self.titleTagLblHeight.constant = [self getTitleTagLblHeight:dic whereCome:whereCome];

    //全部评论
    
    
    if ([dic[@"publish_site"] isEqualToString:@""] || !dic[@"publish_site"] ) {
        self.nameCenter.constant = self.titleImageView.frame.origin.y;
    }else{
        self.nameCenter.constant = 0;
    }

    NSString * zuji = [NSString stringWithFormat:@"来自足迹·%@ %@",dic[@"cigar_info"][@"brand_name"],dic[@"cigar_info"][@"cigar_name"]];
    self.titleTagtextView.text = zuji;

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
- (IBAction)openAction:(id)sender{
    //将当前对象的isShowMoreText属性设为相反值
    self.dataDic[@"isShowMoreText"] = [self.dataDic[@"isShowMoreText"] isEqualToString:@"1"] ? @"0" : @"1";
    if (self.showMoreTextBlock){
        self.showMoreTextBlock(self,self.dataDic);
    }
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
    
    
    _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 200) shouldInfiniteLoop:NO imageNamesGroup:@[]];
    _cycleScrollView3.delegate = self;
    [self.lunBoView addSubview:_cycleScrollView3];
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
