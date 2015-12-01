//
//  HHDownloadOperationManage.h
//  HHDownloadRequestOperation
//
//  Created by caohuihui on 15/8/4.
//  Copyright (c) 2015年 caohuihui. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HHDownloadOperation;

typedef enum HHDownloadOperationState HHDownloadOperationState;

@protocol HHDownloadOperationManageDelegate;

@interface HHDownloadOperationManage : NSObject

@property(nonatomic,assign)id<HHDownloadOperationManageDelegate> delegate;

-(void)setMaxConcurrentOperationCount:(NSInteger)count;

-(void)addOperation:(HHDownloadOperation *)operation;

-(NSArray *)getAllOperation;

-(HHDownloadOperation *)searchDownloadOperation:(NSURL *)url;

@end

@protocol HHDownloadOperationManageDelegate <NSObject>

@optional

-(void)downloadOperationManage:(HHDownloadOperationManage *)manage  downloadOperation:(HHDownloadOperation *)downloadOperation didBeginLoading:(NSURLConnection *)connection;

-(void)downloadOperationManage:(HHDownloadOperationManage *)manage  downloadOperation:(HHDownloadOperation *)downloadOperation didReceiveData:(NSData *)data connection: (NSURLConnection *)connection;

-(void)downloadOperationManage:(HHDownloadOperationManage *)manage  downloadOperation:(HHDownloadOperation *)downloadOperation loadingFinish:(NSURLConnection *)connection;

-(void)downloadOperationManage:(HHDownloadOperationManage *)manage  downloadOperation:(HHDownloadOperation *)downloadOperation loadingFailure:(NSError *)error connection: (NSURLConnection *)connection;

-(void)downloadOperationManage:(HHDownloadOperationManage *)manage  downloadOperation:(HHDownloadOperation *)downloadOperation didChangeState:(HHDownloadOperationState)state;

@end