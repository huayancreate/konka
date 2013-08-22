//
//  WZGuideViewController.m
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import "WZGuideViewController.h"
#import "HYLoginViewController.h"

@interface WZGuideViewController ()
@property (nonatomic) NSArray *imageNameArray;

@end

@implementation WZGuideViewController

@synthesize animating = _animating;

@synthesize pageScroll = _pageScroll;
@synthesize imageNameArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -
#pragma ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.pageScroll.frame.size.width;
    int page = floor((self.pageScroll.contentOffset.x - pagewidth/([imageNameArray count]+2))/pagewidth)+1;
    if(page == imageNameArray.count){
        [[WZGuideViewController sharedGuide] hideGuide];
    }
}


#pragma mark -

- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;
}

- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[WZGuideViewController sharedGuide].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[WZGuideViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideShown
{
	_animating = NO;
}

- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
	[[[WZGuideViewController sharedGuide] view] removeFromSuperview];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

+ (void)show
{
    [[WZGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[WZGuideViewController sharedGuide] showGuide];
}

+ (void)hide
{
	[[WZGuideViewController sharedGuide] hideGuide];
}

#pragma mark - 

+ (WZGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static WZGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton
{
    [checkButton setSelected:!checkButton.selected];
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [[WZGuideViewController sharedGuide] hideGuide];
}


- (void)nextPressButton:(UIButton *)nextEnterButton
{
    CGFloat pagewidth = self.pageScroll.frame.size.width;
    int page = floor((self.pageScroll.contentOffset.x - pagewidth/([imageNameArray count]+2))/pagewidth)+1;
    [_pageScroll scrollRectToVisible:CGRectMake(320 * page + 320 ,0,320,460) animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.imageNameArray = [NSArray arrayWithObjects:@"sys_nav_01.jpg", @"sys_nav_02.jpg", @"sys_nav_03.jpg", @"sys_nav_04.jpg", @"sys_nav_05.jpg",@"sys_nav_06.jpg",@"sys_nav_07.jpg",@"sys_nav_08.jpg",@"sys_nav_09.jpg",@"sys_nav_10.jpg",nil];
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [super screenHeight])];
    _pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * imageNameArray.count, self.view.frame.size.height);
    [self.view addSubview:self.pageScroll];
    _pageScroll.delegate = self;
    NSString *imgName = nil;
    UIView *view;
    for (int i = 0; i < imageNameArray.count; i++) {
        imgName = [imageNameArray objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [super screenHeight])];
        imageView.image = [UIImage imageNamed:imgName];
        view = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i), 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        
        [view addSubview:imageView];
        [self.pageScroll addSubview:view];
        
        if (i == imageNameArray.count - 1) {
//            UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(80.f, 355.f, 15.f, 15.f)];
//            [checkButton setImage:[UIImage imageNamed:@"checkBox_selectCheck"] forState:UIControlStateSelected];
//            [checkButton setImage:[UIImage imageNamed:@"checkBox_blankCheck"] forState:UIControlStateNormal];
//            [checkButton addTarget:self action:@selector(pressCheckButton:) forControlEvents:UIControlEventTouchUpInside];
//            [checkButton setSelected:YES];
//            [view addSubview:checkButton];
            
            UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
            [enterButton setTitle:@"开始使用" forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [enterButton setCenter:CGPointMake(self.view.center.x, [super screenHeight] - 15)];
            
            [enterButton setBackgroundColor:[UIColor colorWithRed:0.000 green:0.478 blue:0.882 alpha:1.0]];
            
            //[enterButton setBackgroundImage:[UIImage imageNamed:@"btn_nor"] forState:UIControlStateNormal];
            //[enterButton setBackgroundImage:[UIImage imageNamed:@"btn_press"] forState:UIControlStateHighlighted];
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:enterButton];
        }else{
            UIButton *nextEnterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
            [nextEnterButton setTitle:@"下一步" forState:UIControlStateNormal];
            [nextEnterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [nextEnterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [nextEnterButton setCenter:CGPointMake(self.view.center.x, [super screenHeight] - 15)];
            
            [nextEnterButton setBackgroundColor:[UIColor colorWithRed:0.000 green:0.478 blue:0.882 alpha:1.0]];
            
            [nextEnterButton addTarget:self action:@selector(nextPressButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:nextEnterButton];

        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
