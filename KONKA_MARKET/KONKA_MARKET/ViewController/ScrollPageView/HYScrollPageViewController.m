//
//  HYScrollPageViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-28.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYScrollPageViewController.h"
#import "HYLoginViewController.h"

@interface HYScrollPageViewController ()


@end

@implementation HYScrollPageViewController
@synthesize scrollView;
@synthesize demoContent;
@synthesize sliderPageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor blackColor]];
		
		self.demoContent = [NSMutableArray new];
		NSMutableDictionary *page1 = [NSMutableDictionary dictionary];
		[page1 setObject:@"登陆" forKey:@"title"];
        UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [imgView1 setImage:[UIImage imageNamed:@"guide_login_1.jpg"]];
        [page1 setObject:imgView1 forKey:@"color"];
        [self.demoContent addObject:page1];
        
        
        
		NSMutableDictionary *page2 = [NSMutableDictionary dictionary];
		[page2 setObject:@"设置" forKey:@"title"];
        UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [imgView2 setImage:[UIImage imageNamed:@"guide_set_2.jpg"]];
        [page2 setObject:imgView2 forKey:@"color"];
		[self.demoContent addObject:page2];
        
		NSMutableDictionary *page3 = [NSMutableDictionary dictionary];
		[page3 setObject:@"销售" forKey:@"title"];
        UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [imgView3 setImage:[UIImage imageNamed:@"guide_sell_3.jpg"]];
        [page3 setObject:imgView3 forKey:@"color"];
		[self.demoContent addObject:page3];
        
		NSMutableDictionary *page4 = [NSMutableDictionary dictionary];
		[page4 setObject:@"其他设置" forKey:@"title"];
        UIImageView *imgView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [imgView4 setImage:[UIImage imageNamed:@"guide_setother_4.jpg"]];
        imgView4.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginView:)];
        [imgView4 addGestureRecognizer:gesture];
        
        [page4 setObject:imgView4 forKey:@"color"];
		[self.demoContent addObject:page4];
		
		self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
		[self.scrollView setPagingEnabled:YES];
		[self.scrollView setContentSize:CGSizeMake([self.demoContent count]*self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
		[self.scrollView setShowsHorizontalScrollIndicator:NO];
		[self.scrollView setDelegate:self];
		[self.view addSubview:self.scrollView];
		
		self.sliderPageControl = [[SliderPageControl  alloc] initWithFrame:CGRectMake(0,[self.view bounds].size.height-20,[self.view bounds].size.width,20)];
		[self.sliderPageControl addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
		[self.sliderPageControl setDelegate:self];
		[self.sliderPageControl setShowsHint:YES];
		[self.view addSubview:self.sliderPageControl];
		[self.sliderPageControl setNumberOfPages:[self.demoContent count]];
		[self.sliderPageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
		
  
        for (int i=0; i<[self.demoContent count]; i++)
		{
			UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*self.scrollView.frame.size.width,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height)];
			[view addSubview:[[self.demoContent objectAtIndex:i] objectForKey:@"color"]];
			[self.scrollView addSubview:view];
		}
		
		[self changeToPage:0 animated:NO];

    }
    return self;
}


-(void)loginView:(UIGestureRecognizer *)gestureRecognizer
{
    HYLoginViewController *loginView = [[HYLoginViewController alloc] initWithNibName:@"HYLoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
	pageControlUsed = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    if (pageControlUsed)
	{
        return;
    }
	
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	[sliderPageControl setCurrentPage:page animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView_
{
	pageControlUsed = NO;
}

#pragma mark sliderPageControlDelegate

- (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page
{
	NSString *hintTitle = [[self.demoContent objectAtIndex:page] objectForKey:@"title"];
	return hintTitle;
}

- (void)onPageChanged:(id)sender
{
	pageControlUsed = YES;
	[self slideToCurrentPage:YES];
	
}

- (void)slideToCurrentPage:(bool)animated
{
	int page = sliderPageControl.currentPage;
	
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:animated];
}

- (void)changeToPage:(int)page animated:(BOOL)animated
{
	[sliderPageControl setCurrentPage:page animated:YES];
	[self slideToCurrentPage:animated];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

@end
