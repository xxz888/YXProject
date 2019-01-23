//
//  YXMineArticleViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/4.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineArticleViewController.h"
#import "YXMineEssayTableViewCell.h"

@interface YXMineArticleViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{
    NSInteger page ;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * heightArray;

@end

@implementation YXMineArticleViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWeakSelf(self);
    NSString * pageString = NSIntegerToNSString(page) ;
    [YX_MANAGER requestEssayListGET:pageString success:^(id object) {
        [[NSUserDefaults standardUserDefaults] setValue:object forKey:@"b3"];
        [weakself.dataArray removeAllObjects];
        [weakself.heightArray removeAllObjects];

        [weakself.dataArray addObjectsFromArray:object];
        for (NSDictionary * dic in object) {
            CGFloat height = [weakself getHTMLHeightByStr:dic[@"essay"]];
            [weakself.heightArray addObject:@(height/2.2)];
        }
   
        [weakself.yxTableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.dataArray = [[NSMutableArray alloc]init];
    self.heightArray = [[NSMutableArray alloc]init];

    [self.yxTableView registerNib:[UINib nibWithNibName:@"YXMineEssayTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXMineEssayTableViewCell"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105+ [self.heightArray[indexPath.row] floatValue];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMineEssayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineEssayTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    [cell.essayTitleImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:[UIImage imageNamed:@"img_moren"]];
    cell.essayNameLbl.text = dic[@"user_name"];
    cell.essayTimeLbl.text = [ShareManager timestampSwitchTime:[dic[@"publish_time"] integerValue] andFormatter:@""];
    [cell.essayWebView loadHTMLString:[self justFitImage:dic[@"essay"]] baseURL:nil];
    return cell;
}
-(NSString *)justFitImage:(NSString *)essay{
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size:15px;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>"
                            "<script type='text/javascript'>"
                            "window.onload = function(){\n"
                            "var $img = document.getElementsByTagName('img');\n"
                            "for(var p in  $img){\n"
                            " $img[p].style.width = '100%%';\n"
                            "$img[p].style.height ='auto'\n"
                            "}\n"
                            "}"
                            "</script>%@"
                            "</body>"
                            "</html>",essay];
    return htmlString;
}
//计算html字符串高度
-(CGFloat )getHTMLHeightByStr:(NSString *)str
{
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]}documentAttributes:NULL error:nil];
    [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, htmlString.length)];
    CGSize textSize = [htmlString boundingRectWithSize:(CGSize){KScreenWidth - 10, CGFLOAT_MAX}options:NSStringDrawingUsesFontLeading || NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return textSize.height;
}
@end
