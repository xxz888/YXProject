//
//  YXMineTongYongTableViewController.m
//  UniversalApp
//
//  Created by 小小醉 on 2019/1/26.
//  Copyright © 2019年 徐阳. All rights reserved.
//

#import "YXMineTongYongTableViewController.h"
#import "YXMineTuiSongViewController.h"
#define PYSEARCH_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"] // the path of search record cached

@interface YXMineTongYongTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheLbl;

@end

@implementation YXMineTongYongTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

    self.cacheLbl.text = [self getCacheSizeWithFilePath:docPath];
    self.automaticallyAdjustsScrollViewInsets=false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"通用";
    self.tableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * stroryBoard4 = [UIStoryboard storyboardWithName:@"YXMine" bundle:nil];

    switch (indexPath.section) {
        case 0:
            //推送
            if (indexPath.row == 0) {
                YXMineTuiSongViewController * VC = [stroryBoard4 instantiateViewControllerWithIdentifier:@"YXMineTuiSongViewController"];
                [self.navigationController pushViewController:VC animated:YES];
            }
            break;
        case 1:
            //清除搜索记录
            if (indexPath.row == 0) {
                QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                }];
                QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"清除搜索记录" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                    YX_MANAGER.isClear = YES;
                    [NSKeyedArchiver archiveRootObject:@[] toFile:PYSEARCH_SEARCH_HISTORY_CACHE_PATH];
                    [QMUITips showSucceed:@"清除成功"];
                }];
                QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"确定要清除搜索记录?" preferredStyle:QMUIAlertControllerStyleActionSheet];
                [alertController addAction:action1];
                [alertController addAction:action2];
                [alertController showWithAnimated:YES];
            //清除缓存
            }else  if (indexPath.row == 1) {
                QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                }];
                QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"清除缓存" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                    YX_MANAGER.isClear = YES;
                    [NSKeyedArchiver archiveRootObject:@[] toFile:PYSEARCH_SEARCH_HISTORY_CACHE_PATH];
                    [QMUITips showSucceed:@"清除成功"];
                    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                    
                    self.cacheLbl.text = @"";
                }];
                QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"确定要清除缓存" preferredStyle:QMUIAlertControllerStyleActionSheet];
                [alertController addAction:action1];
                [alertController addAction:action2];
                [alertController showWithAnimated:YES];
            }
            break;
        default:
            break;
    }
}
/**
 *  计算沙盒相关路径的缓存
 *
 *  @param path 沙盒的路径
 *
 *  @return 缓存的大小（字符串）
 */
- (NSString *)getCacheSizeWithFilePath:(NSString *)path{
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr){
        filePath =[path stringByAppendingPathComponent:subPath];
        BOOL isDirectory = NO;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            continue;
        }
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        totleSize += size;
    }
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleStr;
}

/**
 *  清除沙盒相关路径的缓存
 *
 *  @param path 沙盒相关路径
 *
 *  @return 是否清除成功
 */

- (BOOL)clearCacheWithFilePath:(NSString *)path{
    
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"-----清除缓存的错误信息------%@",error);
            return NO;
        }
    }
    return YES;
}

/**
 *  清除App的缓存
 */
-(void)cleanAppCache{
    
    /**
     * 清除硬盘（沙盒）缓存
     */
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    [self clearCacheWithFilePath:cachesPath];
    
    /**
     *  清除SDWebImage框架的缓存
     */
    [[SDImageCache sharedImageCache] clearDisk];// 清除磁盘缓存上的所有image
    //[[SDImageCache sharedImageCache] clearMemory];// 清楚内存缓存上的所有image
    [[SDImageCache sharedImageCache] cleanDisk];// 清除磁盘缓存上过期的image
    
    /**
     *  清除webView控件的缓存
     */
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
