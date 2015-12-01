//
//  HHDownloadOperation.h
//  HHDownloadOperation
//
//  Created by caohuihui on 15/8/4.
//  Copyright (c) 2015年 caohuihui. All rights reserved.
//

#import <Foundation/Foundation.h>

 enum HHDownloadOperationState
{
    HHDownloadOperationState_Normal = 0,//等待
    HHDownloadOperationState_Loading,//下载中
    HHDownloadOperationState_Pause,//暂停
    HHDownloadOperationState_Finish,//完成
    HHDownloadOperationState_Failure,//失败
};


typedef enum HHDownloadOperationState HHDownloadOperationState;

@protocol HHDownloadOperationDelegate;

@interface HHDownloadOperation : NSOperation
//文件数据
@property(nonatomic,strong)NSMutableData *fileData;
//文件句柄
@property(nonatomic,strong)NSFileHandle *writeHandle;
//当前获取到的数据长度
@property(nonatomic,assign)long long currentLength;
//完整数据长度
@property(nonatomic,assign)long long sumLength;
//是否正在下载
@property(nonatomic,readonly)BOOL downLoading;
//请求对象
@property(nonatomic,strong)NSURLConnection *cnnt;
//进度
@property(nonatomic)float progress;
//状态
@property(atomic,readonly)HHDownloadOperationState state;
//拓展
@property(nonatomic,strong)id object;
//协议
@property(nonatomic,assign)id<HHDownloadOperationDelegate> delegate;
//地址
@property(nonatomic,copy)NSURL * url;
//文件路径
@property(nonatomic,strong)NSString * filePath;

/**
 *  @author caohuihui, 15-08-04
 *
 *  @brief  初始化
 *  @param url    下载地址
 *  @param object 拓展
 *  @param delegate  协议
 *  @param filePath 文件储存路径
 *  @return HHDownloadOperation 实例
 */
-(HHDownloadOperation *)initWithUrl:(NSURL *)url filePath:(NSString *)filePath objetc:(id)object delegate:(id<HHDownloadOperationDelegate>)delegate;

/**
 *  @author caohuihui, 15-08-04
 *
 *  @brief  初始化
 *  @param urlString 地址字符串
 *  @param object    拓展对象
 *  @param delegate  协议
 *  @param filePath 文件储存路径
 *  @return HHDownloadOperation 实例
 */
-(HHDownloadOperation *)initWithUrlString:(NSString *)urlString     filePath:(NSString *)filePath objetc:(id)object delegate:(id<HHDownloadOperationDelegate>)delegate;

/**
 *  @author caohuihui, 15-08-04
 *
 *  @brief  初始化
 *  @param url      下载地址
 *  @param delegate 协议
 *  @param filePath 文件储存路径
 *  @return HHDownloadOperation 实例
 */
-(HHDownloadOperation *)initWithUrl:(NSURL *)url filePath:(NSString *)filePath delegate:(id<HHDownloadOperationDelegate>)delegate;


/**
 *  @author caohuihui, 15-08-04
 *
 *  @brief  初始化
 *  @param urlString 下载地址
 *  @param delegate  协议
 *  @param filePath 文件储存路径
 *  @return HHDownloadOperation 实例
 */
-(HHDownloadOperation *)initWithUrlString:(NSString *)urlString    filePath:(NSString *)filePath delegate:(id<HHDownloadOperationDelegate>)delegate;


/**
 *  @author caohuihui, 15-08-04
 *
 *  @brief  开始下载
 */
-(void)starLoading;

/**
 *  @author caohuihui, 15-08-04
 *
 *  @brief  停止下载(取消下载)
 */
-(void)stopLoading;

/**
 *  @author caohuihui, 15-08-04
 *
 *  @brief  暂停下载
 */
-(void)pauseLoading;

/**
 *  @author caohuihui, 15-08-04
 *
 *  @brief  删除文件
 *  @param error 错误
 *  @return BOOL 删除结果
 */
- (BOOL)removeFileWithError:(NSError *__autoreleasing *)error;

@end


@protocol HHDownloadOperationDelegate <NSObject>

@optional

-(void)downloadOperation:(HHDownloadOperation *)downloadOperation didBeginLoading:(NSURLConnection *)connection;

-(void)downloadOperation:(HHDownloadOperation *)downloadOperation didReceiveData:(NSData *)data connection: (NSURLConnection *)connection;

-(void)downloadOperation:(HHDownloadOperation *)downloadOperation loadingFinish:(NSURLConnection *)connection;

-(void)downloadOperation:(HHDownloadOperation *)downloadOperation loadingFailure:(NSError *)error connection: (NSURLConnection *)connection;

-(void)downloadOperation:(HHDownloadOperation *)downloadOperation didChangeState:(HHDownloadOperationState)state;

@end