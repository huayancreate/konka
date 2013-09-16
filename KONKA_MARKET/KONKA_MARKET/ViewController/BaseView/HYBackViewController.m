//
//  HYBackViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-9-2.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBackViewController.h"

@interface HYBackViewController ()

@end

@implementation HYBackViewController
@synthesize didRequest;
@synthesize detailRequest;
@synthesize uiWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[super someButton] addTarget:self action:@selector(linkBackAction)
         forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backButtonAdd:(NSMutableURLRequest *)_didRequest detailRequest: (NSMutableURLRequest *)_detailRequest uiWebView:(UIWebView *)_uiWebView ID:(id)current
{
//    someButton
    NSLog(@"_didRequest: %@",_didRequest.URL.absoluteString);
    NSLog(@"_didRequest: %@",_detailRequest.URL.absoluteString);
    self.didRequest = _didRequest;
    self.detailRequest = _detailRequest;
    self.uiWebView = _uiWebView;
}



- (NSString*) encodeURL:(NSString *)unescapedString
{
    NSString* escapedUrlString= (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)unescapedString, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
    
    escapedUrlString = [escapedUrlString stringByAddingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
    return escapedUrlString;
}

-(void)linkBackAction
{
    NSLog(@"didRequest: %@", self.didRequest.URL.absoluteString);
    NSLog(@"detailRequest: %@", self.detailRequest.URL.absoluteString);
    if(![self.didRequest.URL.absoluteString isEqualToString:self.detailRequest.URL.absoluteString]){
        NSLog(@"返回按钮的request: %@",didRequest);
        [self.uiWebView loadRequest:self.didRequest];
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
    }
}

@end
