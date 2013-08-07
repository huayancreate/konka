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

@interface HYHomeViewController ()

@end

@implementation HYHomeViewController
@synthesize uiAdvLogoScrollView;
@synthesize slideImages;
@synthesize pageControl;

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
    // 初始化广告滚屏
    // 定时器 循环
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    uiAdvLogoScrollView.bounces = YES;
    uiAdvLogoScrollView.pagingEnabled = YES;
    uiAdvLogoScrollView.userInteractionEnabled = YES;
    uiAdvLogoScrollView.showsHorizontalScrollIndicator = NO;
    
    // 初始化 数组 并添加四张图片
    slideImages = [[NSMutableArray alloc] init];
    [slideImages addObject:@"konka_production_01.jpg"];
    [slideImages addObject:@"konka_production_02.jpg"];
    [slideImages addObject:@"konka_production_03.jpg"];
    [slideImages addObject:@"konka_production_04.jpg"];
    
    // 初始化 pagecontrol
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(220,92,100,18)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    pageControl.numberOfPages = [self.slideImages count];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self.view addSubview:pageControl];
    // 创建四个图片 imageview
    for (int i = 0;i<[slideImages count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:i]]];
        imageView.frame = CGRectMake((320 * i) + 320, 0, 320, 115);
        [uiAdvLogoScrollView addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
    }
    // 取数组最后一张图片 放在第0页
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:([slideImages count]-1)]]];
    imageView.frame = CGRectMake(0, 0, 320, 115); // 添加最后1页在首页 循环
    [uiAdvLogoScrollView addSubview:imageView];
    // 取数组第一张图片 放在最后1页
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:0]]];
    imageView.frame = CGRectMake((320 * ([slideImages count] + 1)) , 0, 320, 115); // 添加第1页在最后 循环
    [uiAdvLogoScrollView addSubview:imageView];
    
    [uiAdvLogoScrollView setContentSize:CGSizeMake(320 * ([slideImages count] + 2), 1)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [uiAdvLogoScrollView setContentOffset:CGPointMake(0, 0)];
    [uiAdvLogoScrollView scrollRectToVisible:CGRectMake(320,0,320,138) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
    //其他初始化
    
    UIImage *setConfigImage = [UIImage imageNamed:@"btn_set_white.png"];
    CGRect frameimg = CGRectMake(0, 20, 30, 30);
    UIButton *configButton = [[UIButton alloc] initWithFrame:frameimg];
    [configButton setBackgroundImage:setConfigImage forState:UIControlStateNormal];
    
    [configButton addTarget:self action:@selector(selectRightAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [configButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:configButton];
    
    
    self.navigationItem.rightBarButtonItem  = rightButton;
    
    UIImage *backButtonImage = [UIImage imageNamed:@"logo.png"];
    UIButton *someButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 220, 35)];
    [someButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [someButton setHighlighted:NO];
    self.navigationItem.leftBarButtonItem  = leftButton;
    
}

// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = uiAdvLogoScrollView.frame.size.width;
    int page = floor((uiAdvLogoScrollView.contentOffset.x - pagewidth/([slideImages count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
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
}
// 定时器 绑定的方法
- (void)runTimePage
{
    int page = pageControl.currentPage; // 获取当前的page
    page++;
    page = page > 3 ? 0 : page ;
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
    oaRetailView.title = @"协同办公";
    
    [self.navigationController pushViewController:oaRetailView animated:YES];
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

@end
