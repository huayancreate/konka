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

- (NSString *)decodeURL: (NSString *) unescapedString
{
    NSMutableString *outputStr = [NSMutableString stringWithString:unescapedString];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(void)linkBackAction
{
    NSLog(@"didRequest: %@", self.didRequest.URL.absoluteString);
    NSLog(@"detailRequest: %@", self.detailRequest.URL.absoluteString);
    [self.uiWebView goBack];
    
    if([self.detailRequest.URL.absoluteString isEqualToString:self.didRequest.URL.absoluteString] ||
       [self.detailRequest.URL.absoluteString isEqualToString:@"about:blank"]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
    }else{
        NSString *return_url = @"__return_url";
        NSRange foundObj=[self.didRequest.URL.absoluteString rangeOfString:return_url options:NSCaseInsensitiveSearch];
        if(foundObj.length>0) {
            NSArray *firstSplit = [self.didRequest.URL.absoluteString componentsSeparatedByString:@"&"];
            NSString *_return_url = [[firstSplit objectAtIndex:3] stringByReplacingOccurrencesOfString:@"__return_url=" withString:@""];
            NSString *request = [self encodeURL: self.detailRequest.URL.absoluteString];
            
            if([_return_url isEqualToString: request]){
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
            }
        }
        else
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
        }
        
    }
}

@end
