//
//  HHDownloadOperation.h
//  HHDownloadOperation
//
//  Created by caohuihui on 15/8/4.
//  Copyright (c) 2015年 caohuihui. All rights reserved.
//

#import "HHDownloadOperation.h"

@interface HHDownloadOperation()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property(nonatomic)HHDownloadOperationState isState;
@property (nonatomic, strong) NSTimer *speedTimer;
@end

@implementation HHDownloadOperation

@synthesize isState = _isState;

-(BOOL)downLoading
{
    if (self.state == HHDownloadOperationState_Loading) {
        return YES;
    }
    return NO;
}

-(void)setIsState:(HHDownloadOperationState)isState
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isCancelled"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isState  = isState;
    if ([self.delegate respondsToSelector:@selector(downloadOperation:didChangeState:)]) {
        [self.delegate downloadOperation:self didChangeState:isState];
    }
    
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isCancelled"];
    [self didChangeValueForKey:@"isFinished"];
    
}

-(HHDownloadOperationState)state
{
    return self.isState;
}

-(HHDownloadOperation *)initWithUrl:(NSURL *)url filePath:(NSString *)filePath delegate:(id<HHDownloadOperationDelegate>)delegate
{
    return [self initWithUrl:url filePath:filePath objetc:nil delegate:delegate];
}


-(HHDownloadOperation *)initWithUrl:(NSURL *)url filePath:(NSString *)filePath objetc:(id)object delegate:(id<HHDownloadOperationDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        self.url = url;
        self.filePath = filePath;
        self.object = object;
        self.delegate = delegate;
    }
    
    return self;
}

-(HHDownloadOperation *)initWithUrlString:(NSString *)urlString  filePath:(NSString *)filePath delegate:(id<HHDownloadOperationDelegate>)delegate
{
    return [self initWithUrlString:urlString filePath:filePath objetc:nil delegate:delegate];
}

-(HHDownloadOperation *)initWithUrlString:(NSString *)urlString  filePath:(NSString *)filePath objetc:(id)object delegate:(id<HHDownloadOperationDelegate>)delegate
{
    NSURL *  url = [NSURL URLWithString:urlString];
    return [self initWithUrl:url filePath:filePath objetc:object delegate:delegate];
}

-(void)start
{
    
    [self starLoading];
    
    if (self.cnnt && ![self isCancelled]) {
        // Start the download
        [self.writeHandle seekToEndOfFile];
        
        NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
        [self.cnnt scheduleInRunLoop:runLoop
                                   forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}


-(void)cancel
{
    [self stopLoading];
    
    self.isState = HHDownloadOperationState_Pause;
}

- (BOOL)isExecuting
{
    return self.state == HHDownloadOperationState_Loading;
}

- (BOOL)isCancelled
{
    return self.state == HHDownloadOperationState_Pause;
}

- (BOOL)isFinished
{
    return self.state == HHDownloadOperationState_Failure || self.state == HHDownloadOperationState_Finish || self.state == HHDownloadOperationState_Pause;
}



-(void)starLoading
{

    if ([self isExecuting]) {
        return;
    }
    
    NSFileManager * fm  = [NSFileManager defaultManager];
    
    //创建一个请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:_url];
    
    if (![fm fileExistsAtPath:self.filePath]) {
        [fm createFileAtPath:self.filePath
                    contents:nil
                  attributes:nil];
    }
    else {
        
        uint64_t fileSize = [[fm attributesOfItemAtPath:self.filePath error:nil] fileSize];
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-", fileSize];
        [request setValue:range forHTTPHeaderField:@"Range"];
        // Allow progress to reflect what's already downloaded
        self.currentLength = fileSize;
        self.sumLength = self.currentLength;
    }

    //创建写数据的文件句柄
    self.writeHandle=[NSFileHandle fileHandleForWritingAtPath:self.filePath];
    
    //发送请求
    self.cnnt=[NSURLConnection connectionWithRequest:request delegate:self];
    [self.cnnt start];
    
    //设置状态
    self.isState = HHDownloadOperationState_Loading;
}

-(void)stopLoading
{
    //取消连接
    [self.cnnt cancel];
    
    [self.writeHandle closeFile];
    self.writeHandle=nil;
    
    self.currentLength = 0;
    self.sumLength = 0;
    
    //设置状态
    self.isState = HHDownloadOperationState_Normal;
    
    //删除下载文件
    
}

-(void)pauseLoading
{
    //设置状态
    self.isState = HHDownloadOperationState_Pause;
    
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.isState = HHDownloadOperationState_Failure;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{

}

#pragma  mark - NSURLConnectionDataDelegate
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //协议回调
    if ([self.delegate respondsToSelector:@selector(downloadOperation:didBeginLoading:)]) {
        [self.delegate downloadOperation:self didBeginLoading:connection];
    }
    
    //获取完整的文件长度
    self.sumLength +=response.expectedContentLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //累加接收到的数据长度
    self.currentLength+=data.length;
    
    //计算进度值
    if (self.sumLength>0) {
        double progress=(double)self.currentLength/self.sumLength;
        self.progress=progress;
        self.progress = progress>1?1:progress;
    }
    
    
    //移动到文件的尾部
    [self.writeHandle seekToEndOfFile];
    
    //从当前移动的位置，写入数据
    [self.writeHandle writeData:data];

    //协议回调
    if ([self.delegate respondsToSelector:@selector(downloadOperation:loadingFinish:)]) {
        [self.delegate downloadOperation:self didReceiveData:data connection:connection];
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.writeHandle closeFile];
    self.writeHandle=nil;
    
    //设置状态
    self.isState = HHDownloadOperationState_Finish;
    
    //清空进度值
    self.currentLength=0;
    self.sumLength=0;
    
    //协议回调
    if ([self.delegate respondsToSelector:@selector(downloadOperation:loadingFinish:)]) {
        [self.delegate downloadOperation:self loadingFinish:connection];
    }
    
}


#pragma mark - 删除文件
- (BOOL)removeFileWithError:(NSError *__autoreleasing *)error
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:self.filePath]) {
        return [fm removeItemAtPath:self.filePath error:error];
    }
    
    return YES;
}

@end
