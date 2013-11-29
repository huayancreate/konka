//
//  DataProcessing.h
//  KONKA
//
//  Created by archon on 12-10-20.
//  Copyright (c) 2012年 HY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHttpHeaders.h"
@interface DataProcessing : NSObject
{
    BOOL bType;
}

+ (DataProcessing *)sharedDataProcessing;

-(BOOL) sentRequest:(NSURL *)url Target:(id)target;
-(BOOL) sentRequest:(NSURL *)url Parem:(NSDictionary*)parem  Target:(id)target ;
-(BOOL) sentGetRequest:(NSString *)url Parem:(NSDictionary*)parem  Target:(id)target;
-(BOOL) sentRequest:(NSURL *)url Parem:(NSDictionary*)parem Files:(NSDictionary*)files Target:(id)target;
-(BOOL) sentPostRequest:(NSURL *)url Parem:(NSDictionary*)parem Target:(id)target ;
-(BOOL) sentSynRequest:(NSURL *)url Parem:(NSDictionary*)parem  Target:(id)target;

-(NSString *) sentSynchronousRequest:(NSURL *)url Parem:(NSDictionary*)parem Files:(NSDictionary*)files Target:(id)target;

-(NSDictionary *) getVersionMsg:(NSString *)version Targe:(id)targe;

-(BOOL) getAccountMsg:(NSString *)string;

@end
