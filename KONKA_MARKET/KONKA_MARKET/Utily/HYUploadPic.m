//
//  HYUploadPic.m
//  KONKA_MARKET
//
//  Created by 许 玮 on 13-12-19.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYUploadPic.h"
#import "DataProcessing.h"
#import "SVProgressHUD.h"
#import "HYSeverContUrl.h"

@implementation HYUploadPic

-(void)addPicWithDictionary:(NSDictionary *)sugestDic Parem:(NSDictionary *) param
{
    
    [SVProgressHUD showWithStatus:@"正在提交数据..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:UploadPic]];
    
    NSLog(@"url 正在提交数据 %@", url.absoluteString);
    [[[DataProcessing alloc] init] sentRequest:url Parem:param Files:sugestDic Target:nil];
    
}

#pragma mark -
#pragma mark DataProcesse
- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endRequest:) withObject:responsestring waitUntilDone:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败";
    [self performSelectorOnMainThread:@selector(endFailedRequest:) withObject:responsestring waitUntilDone:YES];
}

-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:msg];
}

-(void) endRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:msg];
}

@end
