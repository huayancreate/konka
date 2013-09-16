//
//  HYBackViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-9-2.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYBackViewController : HYBaseViewController
@property (nonatomic, strong) NSMutableURLRequest *didRequest;
@property (nonatomic, strong) NSMutableURLRequest *detailRequest;
@property (nonatomic, strong) UIWebView *uiWebView;

-(void)backButtonAdd:(NSMutableURLRequest *)didRequest detailRequest: (NSMutableURLRequest *)detailRequest uiWebView:(UIWebView *)uiWebView ID:(id)current;

-(NSString*) encodeURL:(NSString *)unescapedString;

@end
