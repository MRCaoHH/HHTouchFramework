//
//  ViewController.m
//  HHTouchFrameworkTest
//
//  Created by caohuihui on 15/11/30.
//  Copyright © 2015年 caohuihui. All rights reserved.
//

#import "ViewController.h"
#import "HHDownloadOperationManage.h"
#import "HHDownloadOperation.h"
#import "SSZipArchive.h"
#import "MBProgressHUD.h"

@interface ViewController ()<HHDownloadOperationManageDelegate>
{
    HHDownloadOperationManage * _downloadOperation;
}
@end

@implementation ViewController

#pragma mark - 父类方法 -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _downloadOperation = [[HHDownloadOperationManage alloc]init];
    _downloadOperation.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark 下载事件
- (void)downloadEvent
{
    //framework压缩文件地址:http://wailian.xsscp.com/a/1448883737.zip
    HHDownloadOperation * operation = [[HHDownloadOperation alloc]initWithUrl:[NSURL URLWithString:@"http://wailian.xsscp.com/a/1448883737.zip"] filePath:[self zipPath] delegate:nil];
    [_downloadOperation addOperation:operation];
}

#pragma mark - 点击main按钮
- (IBAction)main:(id)sender {
    //加载动态库
    [self loadTouchFramework];
    
    if ([self checkClassWithName:@"HHFrameworkAPI"]) {
        Class api = NSClassFromString(@"HHFrameworkAPI");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        id vc = [api performSelector:@selector(getMainViewController) withObject:nil];
#pragma clang diagnostic pop
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 点击othe按钮
- (IBAction)othe:(id)sender {
    //加载动态库
    [self loadTouchFramework];
    if ([self checkClassWithName:@"HHFrameworkAPI"]) {
        Class api = NSClassFromString(@"HHFrameworkAPI");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        id vc = [api performSelector:@selector(getOtheViewController) withObject:nil];
#pragma clang diagnostic pop
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 点击下载按钮
- (IBAction)down:(id)sender {
    
    [self downloadEvent];
}

#pragma mark - 点击解压按钮
- (IBAction)unzip:(id)sender {
    
    [SSZipArchive unzipFileAtPath:[self zipPath] toDestination:[self unzipPath]]?NSLog(@"succ"):NSLog(@"fail");
}

#pragma mark - 加载动态库
- (void)loadTouchFramework
{
    NSString *destLibPath = [self frameworkPath];
    
    //判断一下有没有这个文件的存在　如果没有直接跳出
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:destLibPath]) {
        NSLog(@"文件不存在");
        return;
    }
    
    //复制到程序中
    NSError *error = nil;
    

    NSBundle *frameworkBundle = [NSBundle bundleWithPath:destLibPath];
    if (frameworkBundle && [frameworkBundle loadAndReturnError:&error]) {
        NSLog(@"动态库加载成功");
    }else {
        NSLog(@"动态库加载失败，错误信息:%@",error);
        return;
    }
}

#pragma mark - 检查类是否存在
-(BOOL)checkClassWithName:(NSString *)className
{
    Class pacteraClass = NSClassFromString(className);
    if (!pacteraClass) {
        
        return NO;
    }
    return YES;
}

#pragma mark - 协议
#pragma mark - HHDownloadOperationManage
-(void)downloadOperationManage:(HHDownloadOperationManage *)manage  downloadOperation:(HHDownloadOperation *)downloadOperation didBeginLoading:(NSURLConnection *)connection
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)downloadOperationManage:(HHDownloadOperationManage *)manage  downloadOperation:(HHDownloadOperation *)downloadOperation didReceiveData:(NSData *)data connection: (NSURLConnection *)connection
{
    
}

-(void)downloadOperationManage:(HHDownloadOperationManage *)manage  downloadOperation:(HHDownloadOperation *)downloadOperation loadingFinish:(NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)downloadOperationManage:(HHDownloadOperationManage *)manage  downloadOperation:(HHDownloadOperation *)downloadOperation loadingFailure:(NSError *)error connection: (NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)downloadOperationManage:(HHDownloadOperationManage *)manage  downloadOperation:(HHDownloadOperation *)downloadOperation didChangeState:(HHDownloadOperationState)state
{
    
}

#pragma mark - 路径 - 
-(NSString *)zipPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentDirectory = nil;
    if ([paths count] != 0)
        documentDirectory = [paths objectAtIndex:0];
    
    //压缩包路径
    NSString *libName = @"1.zip";
    NSString *destLibPath = [documentDirectory stringByAppendingPathComponent:libName];
    return destLibPath;
}

-(NSString *)frameworkPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentDirectory = nil;
    if ([paths count] != 0)
        documentDirectory = [paths objectAtIndex:0];
    
    //拼接我们放到document中的framework路径
    NSString *libName = @"HHFramework.framework";
    NSString *destLibPath = [documentDirectory stringByAppendingPathComponent:libName];
    return destLibPath;
}

-(NSString *)unzipPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentDirectory = nil;
    if ([paths count] != 0)
        documentDirectory = [paths objectAtIndex:0];
    
    //拼接我们放到document中的framework路径
    NSString *libName = @"";
    NSString *destLibPath = [documentDirectory stringByAppendingPathComponent:libName];
    return destLibPath;
}
@end
