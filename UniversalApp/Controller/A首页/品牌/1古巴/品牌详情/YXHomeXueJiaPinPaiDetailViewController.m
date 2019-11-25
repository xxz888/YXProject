//
//  YXHomeXueJiaPinPaiDetailViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/7.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXHomeXueJiaPinPaiDetailViewController.h"
#import "YXHomeXueJiaDetailTableViewCell.h"
#import "CatZanButton.h"
#import "POPAnimation.h"

@interface YXHomeXueJiaPinPaiDetailViewController()<ClickLikeBtnDelegate,UIWebViewDelegate>{
    UIImage * _selImage;
    UIImage * _unImage;
    CGFloat section0Height;
    CGFloat tagHeight;
    CGFloat stringHeight;
}

@end
@implementation YXHomeXueJiaPinPaiDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setSpace];

    [self initData];
}
-(void)setSpace{
    
    NSDictionary * cellData = self.dicStartData;

    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[cellData[@"intro"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    self.section1TextView.attributedText = attributedString;
 
    
    
    self.webView.delegate = self;
    //获取bundlePath 路径
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    //获取本地html目录 basePath
    NSString *basePath = [NSString stringWithFormat:@"%@/%@",bundlePath,@"html"];
    //获取本地html目录 baseUrl
    NSURL *baseUrl = [NSURL fileURLWithPath: basePath isDirectory: YES];
    //显示内容
    if (cellData[@"intro"]) {
        [self.webView loadHTMLString:[ShareManager adaptWebViewForHtml:cellData[@"intro"]] baseURL: baseUrl];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)wb{
      tagHeight = [[wb stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    [self.tableView reloadData];
}


-(void)initData{
    NSDictionary * cellData = self.dicStartData;

    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"YXHomeXueJiaDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXHomeXueJiaDetailTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//推荐该方法

    
    
    _selImage = [UIImage imageNamed:@"Zan"];
    _unImage = [UIImage imageNamed:@"UnZan"];

    self.title = cellData[@"cigar_brand"];
    
    
    NSString * str = [(NSMutableString *)cellData[@"photo"] replaceAll:@" " target:@"%20"];
    [self.section1ImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    [self.section1ImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.section1TextView.text = kGetString(cellData[@"intro"]);
    self.section1TitleLbl.text = [NSString stringWithFormat:@"%@",cellData[@"cigar_brand"]];

    ViewBorderRadius(self.section1GuanZhuBtn, 5, 1, self.section1GuanZhuBtn.titleLabel.textColor);
    
    self.section1countLbl.text = [kGetString(self.dicData[@"concern_number"]) append:@" 人关注"];
    BOOL isGuanZhu = [self.dicData[@"is_concern"] integerValue] == 1;
      [ShareManager setGuanZhuStatus:self.section1GuanZhuBtn status:!isGuanZhu alertView:NO];
    
    

}

-(void)setguanzhu{

  
}


//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){//
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return [self.dicData[@"data"] count];//商品颜色的数组
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        NSDictionary * cellData = self.dicData[@"data"][indexPath.row];
        YXHomeXueJiaDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeXueJiaDetailTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        NSString * url = [cellData[@"photo_list"] count] > 0 ? cellData[@"photo_list"][0][@"photo_url"] : @"";
        NSString * str = [(NSMutableString *)url replaceAll:@" " target:@"%20"];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [cell.section2ImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_moren"]];
        cell.whereCome = self.whereCome;
        
        
        
        cell.section2TitleLbl.text = cellData[@"cigar_name"];
        
        NSString * string = @"暂无售价";
        NSString * str1 = [kGetString(cellData[@"price_single_china"]) isEqualToString:@"0"] ? string : kGetString(cellData[@"price_single_china"]) ;
        cell.section2Lbl1.text = [str1 concate:@"国内售价:"] ;
        [ShareManager setLineSpace_Price_RedColor:1 withText:cell.section2Lbl1.text inLabel:cell.section2Lbl1 tag:[cell.section2Lbl1.text split:@":"][1]];
        
        
        NSString * str2 = [kGetString(cellData[@"price_single_hongkong"]) isEqualToString:@"0"] ? string :
        kGetString(cellData[@"price_single_hongkong"]);
        cell.section2Lbl2.text = [str2 concate:@"香港PCC:"];
           [ShareManager setLineSpace_Price_RedColor:1 withText:cell.section2Lbl2.text inLabel:cell.section2Lbl2 tag:[cell.section2Lbl2.text split:@":"][1]];
        
        
        NSString * str3 = [kGetString(cellData[@"price_single_overseas"]) isEqualToString:@"0"] ? string :
        kGetString(cellData[@"price_single_overseas"]);
        cell.section2Lbl3.text = [str3 concate:@"比站:"];
                   [ShareManager setLineSpace_Price_RedColor:1 withText:cell.section2Lbl3.text inLabel:cell.section2Lbl3 tag:[cell.section2Lbl3.text split:@":"][1]];
        
        
        
        cell.section2Lbl4.text = [kGetString(cellData[@"price_box_china"]) append:@"元"];
        cell.section2Lbl5.text = [kGetString(cellData[@"price_single_china"]) append:@"元/支"];
        cell.section2Lbl6.text = [NSString stringWithFormat:@"%@/盒(%@支)",cellData[@"price_box_china"],cellData[@"box_size"]];
           [ShareManager setLineSpace_Price_RedColor:1 withText:cell.section2Lbl1.text inLabel:cell.section2Lbl1 tag:[cell.section2Lbl1.text split:@":"][1]];
        
        
        
        cell.cigar_id = kGetString(cellData[@"id"]);
        //yes为足迹进来 no为正常进入  足迹进来
        cell.stackView1.hidden = cell.likeBtn.hidden = cell.zanCountLbl.hidden = cell.lineView.hidden = self.whereCome;
        [cell.likeBtn setBackgroundImage:[cellData[@"is_collect"] integerValue] == 1  || !cellData[@"is_collect"] ? _selImage:_unImage forState:UIControlStateNormal];
        cell.zanCountLbl.text = kGetString(cellData[@"collect_number"]);
        if (self.whereCome) {
            tableView.separatorStyle = 0;
        }
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品
        if (self.whereCome) {
            return 0;
        }else{
            return  [self.openBtn.titleLabel.text isEqualToString:@"↑ 收起"]  ? 490-120+tagHeight + 22  : 490 ;
        }
        
    }else{
        //yes为足迹进来 no为正常进入  足迹进来需隐藏热门商品
        return self.whereCome ? 140 - 35 : 185 - 35 ;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (indexPath.section == 1) {
//
//         //yes为足迹进来 no为正常进入
//        if (self.whereCome) {
//             YXPublishFootViewController * footVC = [[YXPublishFootViewController alloc]init];
//            footVC.cigar_id = kGetString(self.dicData[@"data"][indexPath.row][@"id"]);
//            [self presentViewController:footVC animated:YES completion:nil];
//        }else{
//                kWeakSelf(self);
//                UIStoryboard * stroryBoard1 = [UIStoryboard storyboardWithName:@"YXHome" bundle:nil];
//                YXHomeXueJiaPinPaiLastDetailViewController * VC = [stroryBoard1 instantiateViewControllerWithIdentifier:@"YXHomeXueJiaPinPaiLastDetailViewController"];
//                VC.startDic = [NSMutableDictionary dictionaryWithDictionary:self.dicData[@"data"][indexPath.row]];
//                VC.PeiJianOrPinPai = NO;
//
//                //请求六宫格图片
//                NSString * tag = VC.startDic[@"cigar_name"];
//               [QMUITips showLoadingInView:weakself.view];
//                [YX_MANAGER requestSearchFind_all:@{@"key":tag,@"key_unicode":[tag utf8ToUnicode],@"page":@"1",@"type":@"3"} success:^(id object) {
//
//                NSMutableArray * imageArray = [NSMutableArray array];
//                for (NSDictionary * dic in object) {
//                    for (NSString * string in dic[@"url_list"]) {
//                        [imageArray addObject:string];
//                    }
//                }
//                    [QMUITips hideAllTipsInView:weakself.view];
//                [VC.startDic setValue:weakself.title forKey:@"cigar_brand"];
//                VC.imageArray = [NSMutableArray arrayWithArray:imageArray];
//                [weakself.navigationController pushViewController:VC animated:YES];
//            }];
//
//
//                [YX_MANAGER requestGetDetailListPOST:@{@"type":@(0),@"tag":tag,@"page":@(1)} success:^(id object) {
//
//
//            }];
//
//        }
//
//    }
}
-(void)requestLiuGongGe{

}
#pragma mark ========== 关注作者的方法 ==========
- (IBAction)section1GuanZhuAction:(id)sender {
    if ([userManager loadUserInfo]) {
        [self requestMy_concern_cigar];
    }else{
        KPostNotification(KNotificationLoginStateChange, @NO)
    }
}
#pragma mark ========== 点赞按钮 ==========
-(void)clickLikeBtn:(BOOL)isZan cigar_id:(NSString *)cigar_id likeBtn:(nonnull UIButton *)likeBtn{
    kWeakSelf(self);
    if ([userManager loadUserInfo]) {
        
        [YXPLUS_MANAGER requestCollect_optionGet:[@"1/" append:cigar_id] success:^(id object) {
            [weakself requestCigar_brand_details];
        }];
    }else{
        KPostNotification(KNotificationLoginStateChange, @NO)
    }
}
#pragma mark ========== 重新请求详情 ==========
-(void)requestCigar_brand_details{
    kWeakSelf(self);
    [YX_MANAGER requestCigar_brand_detailsPOST:@{@"cigar_brand_id":kGetString(self.dicStartData[@"id"])} success:^(id object) {
        
        
        NSMutableDictionary * dicCopy  =[[NSMutableDictionary alloc]initWithDictionary:object];
        NSMutableArray * copyArray = [[NSMutableArray alloc] initWithArray:dicCopy[@"data"]];
        for (NSInteger i = 0; i < [object[@"data"] count]; i++) {
            NSDictionary * dic = object[@"data"][i];
            if ([dic[@"is_show"] integerValue] == 0) {
                [copyArray removeObjectAtIndex:i];
            }
        }
        [dicCopy setValue:copyArray forKey:@"data"];
        
       weakself.dicData = [NSMutableDictionary dictionaryWithDictionary:dicCopy];
        [weakself.tableView reloadData];
        weakself.section1countLbl.text = [kGetString(self.dicData[@"concern_number"]) append:@" 人关注"];
        BOOL isGuanZhu = [self.dicData[@"is_concern"] integerValue] == 1;
        [ShareManager setGuanZhuStatus:self.section1GuanZhuBtn status:!isGuanZhu alertView:YES];
    }];
}
#pragma mark ========== 请求是否关注 ==========
-(void)requestMy_concern_cigar{
    kWeakSelf(self);
    NSDictionary * cellData = self.dicStartData;
    [YXPLUS_MANAGER requestCollect_optionGet:[@"2/" append:kGetString(cellData[@"id"])] success:^(id object) {
        [weakself requestCigar_brand_details];
    }];
}

- (IBAction)backVCAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openAction:(id)sender {
    if ([self.openBtn.titleLabel.text isEqualToString:@"↓ 展开"]) {
//        self.textViewHeight.constant =  stringHeight ;
//        section0Height =  tagHeight - 120 + 20 + stringHeight ;
        self.zhushiHeight.constant = 22;
        self.textViewHeight.constant = tagHeight;
        [self.openBtn setTitle:@"↑ 收起" forState:UIControlStateNormal];

    }else{
//        self.textViewHeight.constant = stringHeight  > 120 ? 120 : stringHeight ;
//        section0Height = stringHeight  > 120 ? tagHeight : tagHeight - 120 + stringHeight ;
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        self.zhushiHeight.constant = 0;
        self.textViewHeight.constant = 120;

        [self.openBtn setTitle:@"↓ 展开" forState:UIControlStateNormal];


    }
    [self.tableView reloadData];
}

@end
