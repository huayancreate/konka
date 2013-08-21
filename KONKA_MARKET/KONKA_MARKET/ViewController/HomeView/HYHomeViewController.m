//
//  HYHomeViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-3.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYHomeViewController.h"
#import "HYRetailViewController.h"
#import "HYSystemConfigViewController.h"    
#import "HYOAViewController.h"
#import "HYNewsPlatFormViewController.h"
#import "HYOARetailViewController.h"
#import "SDImageView+SDWebCache.h"
#import "HYWebBaseViewController.h"
#import "HYCustomRetailViewController.h"

@interface HYHomeViewController ()
{
    JSONDecoder* decoder;
    UIImageView *firstImageView;
    
    NSMutableArray *leaderList,*customerList,*promotersList;
}

@end

@implementation HYHomeViewController
@synthesize uiAdvLogoScrollView;
@synthesize slideImages;
@synthesize pageControl;
@synthesize linkList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDictionary *dic0 = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"imagepath",@"客户管理",@"name",@"",@"btnclickname",nil];
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"imagepath",@"决策分析",@"name",@"",@"btnclickname",nil];
        NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"imagepath",@"订单系统",@"name",@"",@"btnclickname",nil];
        NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"imagepath",@"零售通",@"name",@"",@"btnclickname",nil];
        NSDictionary *dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"imagepath",@"行政办公",@"name",@"",@"btnclickname",nil];
        NSDictionary *dic5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"imagepath",@"促销管理",@"name",@"",@"btnclickname",nil];
        NSDictionary *dic6 = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"imagepath",@"资讯平台",@"name",@"",@"btnclickname",nil];
        NSDictionary *dic7 = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"imagepath",@"系统设置",@"name",@"",@"btnclickname",nil];
        leaderList = [[NSMutableArray alloc] init];
        customerList = [[NSMutableArray alloc] init];
        promotersList = [[NSMutableArray alloc] init];
        [leaderList addObject:dic0];
        [leaderList addObject:dic1];
        [leaderList addObject:dic2];
        [leaderList addObject:dic3];
        [leaderList addObject:dic4];
        [leaderList addObject:dic5];
        [leaderList addObject:dic6];
        [leaderList addObject:dic7];
        [customerList addObject:dic3];
        [customerList addObject:dic2];
        [customerList addObject:dic5];
        [customerList addObject:dic6];
        [customerList addObject:dic7];
        [promotersList addObject:dic3];
        [promotersList addObject:dic5];
        [promotersList addObject:dic6];
        [promotersList addObject:dic7];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    decoder = [[JSONDecoder alloc] init];
    linkList = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    // 初始化广告滚屏
    // 定时器 循环
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    
    firstImageView = [[UIImageView alloc] init];
    firstImageView.frame = CGRectMake(0, 0, 320, 150);
    firstImageView.image = [UIImage imageNamed:@"konka_production_01.jpg"];
    
    uiAdvLogoScrollView.bounces = YES;
    uiAdvLogoScrollView.pagingEnabled = YES;
    uiAdvLogoScrollView.userInteractionEnabled = YES;
    uiAdvLogoScrollView.showsHorizontalScrollIndicator = NO;
    uiAdvLogoScrollView.delegate = self;
    
    [uiAdvLogoScrollView addSubview:firstImageView];
    
    // 初始化 数组 并添加四张图片
    slideImages = [[NSMutableArray alloc] init];
    [self insertImageToHeader];
    
    //其他初始化
    UIImage *setConfigImage = [UIImage imageNamed:@"headset"];
    CGRect frameimg = CGRectMake(0, 20, 30, 30);
    UIButton *configButton = [[UIButton alloc] initWithFrame:frameimg];
    [configButton setBackgroundImage:setConfigImage forState:UIControlStateNormal];
    
    [configButton addTarget:self action:@selector(selectRightAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [configButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:configButton];
    
    
    self.navigationItem.rightBarButtonItem  = rightButton;
    
    UIImage *backButtonImage = [UIImage imageNamed:@"headbglogo"];
    UIButton *someButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 220, 35)];
    [someButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [someButton setHighlighted:NO];
    self.navigationItem.leftBarButtonItem  = leftButton;
    
    
    [self loadHomeImages];
    
    
    //根据权限画首页画面
    [self createMainView];
    
}



-(void) createMainView
{
    //创建按钮对象
    //[self createBtnObject];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(22, 159, 64, 64)];
    UIImage *image1 = [UIImage imageNamed:@"iconbg.png"];
    imageView1.image = image1;
    [self.view addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(123, 159, 64, 64)];
    UIImage *image2 = [UIImage imageNamed:@"iconbg.png"];
    imageView2.image = image2;
    [self.view addSubview:imageView2];
}

-(void)insertImageToHeader
{
    if ( [slideImages count] == 0)
    {
        return;
    }
    [firstImageView removeFromSuperview];
    [uiAdvLogoScrollView setContentSize:CGSizeMake(320 * ([slideImages count] + 2), 1)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [uiAdvLogoScrollView setContentOffset:CGPointMake(0, 0)];
    [uiAdvLogoScrollView scrollRectToVisible:CGRectMake(320,0,320,150) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
    for (int i = 0;i<[slideImages count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake((320 * i)+320, 0, 320, 150);
        NSURL *url = [[NSURL alloc] initWithString:[slideImages objectAtIndex:i]];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *jump = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleJump:)];
        [imageView addGestureRecognizer:jump];
        [imageView setImageWithURL:url];
        [uiAdvLogoScrollView addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
    }
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.frame = CGRectMake(0, 0, 320, 148);
    NSURL *url1 = [[NSURL alloc] initWithString:[slideImages objectAtIndex:([slideImages count] - 1)]];
    [imageView1 setImageWithURL:url1];
    [uiAdvLogoScrollView addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.frame = CGRectMake(320 * [slideImages count] + 320, 0, 320, 150);
    NSURL *url2 = [[NSURL alloc] initWithString:[slideImages objectAtIndex:0]];
    [imageView2 setImageWithURL:url2];
    [uiAdvLogoScrollView addSubview:imageView2];
    
    
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(220,92,100,18)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    pageControl.numberOfPages = [self.slideImages count];
    pageControl.currentPage = 0;

}

-(void)handleJump:(UIGestureRecognizer *)gestureRecognizer
{
    HYWebBaseViewController *webView = [[HYWebBaseViewController alloc] init];
    webView.link_url = [self.linkList objectAtIndex:pageControl.currentPage];
    webView.userLogin = self.userLogin;
    webView.title = @"资讯展示";
    [self.navigationController pushViewController:webView animated:YES];
}

// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = uiAdvLogoScrollView.frame.size.width;
    int page = floor((uiAdvLogoScrollView.contentOffset.x - pagewidth/([slideImages count]+2))/pagewidth)+1;
    pageControl.currentPage = page;
    
}

// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = uiAdvLogoScrollView.frame.size.width;
    int currentPage = floor((uiAdvLogoScrollView.contentOffset.x - pagewidth/ ([slideImages count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [uiAdvLogoScrollView scrollRectToVisible:CGRectMake(320 * [slideImages count],0,320,460) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([slideImages count]+1))
    {
        [uiAdvLogoScrollView scrollRectToVisible:CGRectMake(320,0,320,460) animated:NO]; // 最后+1,循环第1页
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = pageControl.currentPage; // 获取当前的page
    [uiAdvLogoScrollView scrollRectToVisible:CGRectMake(320*(page+1),0,320,460) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
    pageControl.currentPage = page + 1;
}
// 定时器 绑定的方法
- (void)runTimePage
{
    
    NSLog(@"pageControl.currentPage %d",pageControl.currentPage);
    int page = pageControl.currentPage; // 获取当前的page
    page++;
    NSLog(@"slideImages count %d",page);
    page = page > [slideImages count] - 1? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}

-(void)selectRightAction:(id)sender
{   
    HYSystemConfigViewController *sysconfigView = [[HYSystemConfigViewController alloc] init];
    sysconfigView.userLogin = self.userLogin;
    NSLog(@"系统设置  selectRightAction self.userLogin.user_name %@",self.userLogin.user_name);
    sysconfigView.title = @"系统设置";
    [self.navigationController pushViewController:sysconfigView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retail:(id)sender
{
    HYRetailViewController *retailView = [[HYRetailViewController alloc] init];
    retailView.userLogin = self.userLogin;
    retailView.title = @"零售通";
    
    [self.navigationController pushViewController:retailView animated:YES];
}

-(IBAction)oaAction:(id)sender
{
    HYOARetailViewController  *oaRetailView = [[HYOARetailViewController alloc] init];
    oaRetailView.userLogin = self.userLogin;
    oaRetailView.title = @"行政办公";
    
    [self.navigationController pushViewController:oaRetailView animated:YES];
}

- (IBAction)customAction:(id)sender
{
    HYCustomRetailViewController *customView = [[HYCustomRetailViewController alloc]
                                            init];
    customView.userLogin = self.userLogin;
    customView.title = @"客户管理";
    [self.navigationController pushViewController:customView animated:YES];
    
}

-(IBAction)newsAction:(id)sender
{
    HYNewsPlatFormViewController *newsView = [[HYNewsPlatFormViewController alloc] init];
    newsView.userLogin = self.userLogin;
    newsView.title = @"资讯平台";
    
    [self.navigationController pushViewController:newsView animated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

-(void) sysconfigAction:(id)sender
{
    HYSystemConfigViewController *sysconfigView = [[HYSystemConfigViewController alloc] init];
    sysconfigView.userLogin = self.userLogin;
    NSLog(@"系统设置  selectRightAction self.userLogin.user_name %@",self.userLogin.user_name);
    sysconfigView.title = @"系统设置";
    [self.navigationController pushViewController:sysconfigView animated:YES];
}

-(void) loadHomeImages
{
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"getJson",@"method",self.userLogin.user_name,@"username",self.userLogin.password,@"userpass",@"1100",@"type_id",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:HomeImageApi]];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}

-(void) endRequest:(NSString *)msg
{
    [slideImages removeAllObjects];    
    NSLog(@"MSG endRequest%@",msg );
    [SVProgressHUD dismiss];
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSString *imgPath = nil;
    NSArray* json = [decoder objectWithData:data];
    NSLog(@"JSON count %d",[json count]);
    for(int i=0;i<json.count;i++){
        NSDictionary *dictionary = [json objectAtIndex:i];
        
        imgPath = [dictionary objectForKey:@"image_path"];
        NSLog(@"imgPath %@",imgPath);
        [slideImages addObject:imgPath];
        NSLog(@"linkList %@",[dictionary objectForKey:@"image_url"]);
        [self.linkList addObject:[dictionary objectForKey:@"image_url"]];
    }
    [self insertImageToHeader];
}

-(void) ImageClick
{
    NSLog(@"点击事件");
}
@end
