//
//  HYSystemHelpViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-8-7.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYSystemHelpViewController.h"

@interface HYSystemHelpViewController ()

@end

@implementation HYSystemHelpViewController
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
    // Do any additional setup after loading the view from its nib.
     // 初始化广告滚屏
     // 定时器 循环
//     [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    NSLog(@"viewDidLoad");
    uiAdvLogoScrollView.delegate = self;
     uiAdvLogoScrollView.bounces = YES;
     uiAdvLogoScrollView.pagingEnabled = YES;
     uiAdvLogoScrollView.userInteractionEnabled = YES;
     uiAdvLogoScrollView.showsHorizontalScrollIndicator = NO;
     
     // 初始化 数组 并添加四张图片
     slideImages = [[NSMutableArray alloc] init];
     [slideImages addObject:@"sys_nav_01.jpg"];
     [slideImages addObject:@"sys_nav_02.jpg"];
     [slideImages addObject:@"sys_nav_03.jpg"];
     [slideImages addObject:@"sys_nav_04.jpg"];
     [slideImages addObject:@"sys_nav_05.jpg"];
     [slideImages addObject:@"sys_nav_06.jpg"];
     [slideImages addObject:@"sys_nav_07.jpg"];
     [slideImages addObject:@"sys_nav_08.jpg"];
     [slideImages addObject:@"sys_nav_09.jpg"];
     [slideImages addObject:@"sys_nav_10.jpg"];

     for (int i = 0;i<[slideImages count];i++)
     {
         UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:i]]];
         imageView.frame = CGRectMake((320 * i) + 320, 0, 320, 480);
         [uiAdvLogoScrollView addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
     }
     // 取数组最后一张图片 放在第0页
     UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:(0)]]];
     imageView.frame = CGRectMake(0, 0, 320, 480); // 添加最后1页在首页 循环
     [uiAdvLogoScrollView addSubview:imageView];
     [uiAdvLogoScrollView setContentSize:CGSizeMake(320 * ([slideImages count] + 2), 1)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
     [uiAdvLogoScrollView setContentOffset:CGPointMake(0, 0)];
     [uiAdvLogoScrollView scrollRectToVisible:CGRectMake(320,0,320,480) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
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
    pageControl.currentPage = page;
}

// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = uiAdvLogoScrollView.frame.size.width;
    int currentPage = floor((uiAdvLogoScrollView.contentOffset.x - pagewidth/ ([slideImages count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    NSLog(@"currentPage %d",currentPage);
    if (currentPage==0)
    {

    }
    else if (currentPage==([slideImages count])  - 1)
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
//        [uiAdvLogoScrollView scrollRectToVisible:CGRectMake(320,0,320,480) animated:NO]; // 最后+1,循环第1页
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
