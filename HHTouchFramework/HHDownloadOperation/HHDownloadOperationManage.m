//
//  HHDownloadOperationManage.m
//  HHDownloadRequestOperation
//
//  Created by caohuihui on 15/8/4.
//  Copyright (c) 2015年 caohuihui. All rights reserved.
//

#import "HHDownloadOperationManage.h"
#import "HHDownloadOperation.h"

@interface HHDownloadOperationManage()<HHDownloadOperationDelegate>
@property(nonatomic,strong)NSOperationQueue *  operationQueue;//操作线程
@end

@implementation HHDownloadOperationManage

-(NSOperationQueue *)operationQueue
{
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc]init];
        [_operationQueue setName:@"HHDownloadOperationManage"];
    }
    return _operationQueue;
}

-(void)setMaxConcurrentOperationCount:(NSInteger)count
{
    [self.operationQueue setMaxConcurrentOperationCount:count];
}

-(void)addOperation:(HHDownloadOperation *)operation
{
    if (!operation) return;
    operation.delegate = self;
    [self.operationQueue addOperation:operation];
}

-(NSArray *)getAllOperation
{
    return self.operationQueue.operations;
}

-(HHDownloadOperation *)searchDownloadOperation:(NSURL *)url
{
    NSArray * array = [self getAllOperation];
    
    for (HHDownloadOperation * operation in array) {
        if ([operation.url.absoluteString isEqualToString:url.absoluteString]) {
            return operation;
        }
    }

    return nil;
}

#pragma mark - HHDownloadOperationDelegate

-(void)downloadOperation:(HHDownloadOperation *)downloadOperation didBeginLoading:(NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(downloadOperationManage:downloadOperation:didBeginLoading:)]) {
        [self.delegate downloadOperationManage:self downloadOperation:downloadOperation didBeginLoading:connection];
    }
}

-(void)downloadOperation:(HHDownloadOperation *)downloadOperation didReceiveData:(NSData *)data connection: (NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(downloadOperationManage:downloadOperation:didReceiveData:connection:)]) {
        [self.delegate downloadOperationManage:self downloadOperation:downloadOperation didReceiveData:data connection:connection];
    }
}

-(void)downloadOperation:(HHDownloadOperation *)downloadOperation loadingFinish:(NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(downloadOperationManage:downloadOperation:loadingFinish:)]) {
        [self.delegate downloadOperationManage:self downloadOperation:downloadOperation loadingFinish:connection];
    }
}

-(void)downloadOperation:(HHDownloadOperation *)downloadOperation loadingFailure:(NSError *)error connection: (NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(downloadOperationManage:downloadOperation:loadingFailure:connection:)]) {
        [self.delegate downloadOperationManage:self downloadOperation:downloadOperation loadingFailure:error connection:connection];
    }
}

-(void)downloadOperation:(HHDownloadOperation *)downloadOperation didChangeState:(HHDownloadOperationState)state
{
    if ([self.delegate respondsToSelector:@selector(downloadOperationManage:downloadOperation:didChangeState:)]) {
        [self.delegate downloadOperationManage:self downloadOperation:downloadOperation didChangeState:state];
    }
}
@end
