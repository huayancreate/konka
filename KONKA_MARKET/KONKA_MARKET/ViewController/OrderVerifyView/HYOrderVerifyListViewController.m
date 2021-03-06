//
//  HYOrderVerifyListViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-8-28.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYOrderVerifyListViewController.h"

@interface HYOrderVerifyListViewController ()
{
    NSMutableURLRequest *request;
}

@end

@implementation HYOrderVerifyListViewController
@synthesize didRequest;
@synthesize detailRequest;
@synthesize backView;


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
    // Do any additional setup after loading the view from its nib.
    self.uiWebView.delegate = self;
    self.uiWebView.scrollView.delegate = self;
    
    //初始化refreshView，添加到webview 的 scrollView子视图中
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-self.uiWebView.scrollView.bounds.size.height, self.uiWebView.scrollView.frame.size.width, self.uiWebView.scrollView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [self.uiWebView.scrollView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    NSLog(@"username %@",self.userLogin.user_name);
    
    //NSString *username = [self.userLogin.user_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@?method=loginOnGet&__username=%@&__password=%@&__return_url=%@", BaseVipURL, LoginOnGetApi,[self encodeURL:self.userLogin.user_name],self.userLogin.password,[self encodeURL:@"http://vip.konka.com/customer/manager/JxcKonkaOrderRegister.do?method=listInMobile"]];
//    
//    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?method=loginOnGet&__username=%@&__password=%@&__return_url=%@", BaseURL, LoginOnGetApi,[self encodeURL:self.userLogin.user_name],self.userLogin.password,[self encodeURL:@"http://qdgl.konka.com/KonkaOrderAudit.do?method=list"]];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    
    request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSLog(@"request url %@", urlStr);
    [self loadPage];
    [SVProgressHUD dismiss];
    
    backView = [[HYBackViewController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加载网页
- (void)loadPage {
    NSLog(@"request %@", [request valueForHTTPHeaderField:@"forward"]);
    didRequest = request;
    [self.uiWebView loadRequest:request];
}

#pragma mark - webview delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _reloading = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    detailRequest = (NSMutableURLRequest *)webView.request;
    NSLog(@"detailrequest 12312 %@",detailRequest.URL.absoluteString);
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.uiWebView.scrollView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"load page error:%@", [error description]);
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.uiWebView.scrollView];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self loadPage];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)vie{
	
	return [NSDate date]; // should return date data source was last changed
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)_request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"test");
    NSLog(@"获取请求的request: %@", didRequest);
    NSLog(@"test end");
    //request = (NSMutableURLRequest *)_request;
    //detailRequest = (NSMutableURLRequest *)_request;
    [backView backButtonAdd:didRequest detailRequest:detailRequest uiWebView:self.uiWebView ID:self];
    return YES;
}

@end
