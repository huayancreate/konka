//
//  RootScrollView.m
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import "RootScrollView.h"
#import "Globle.h"
#import "TopScrollView.h"

#define POSITIONID (int)scrollView.contentOffset.x/320

@implementation RootScrollView

@synthesize viewNameArray;

+ (RootScrollView *)shareInstance {
    static RootScrollView *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[self alloc] initWithFrame:CGRectMake(0, 44, 320, [Globle shareInstance].globleHeight-44)];
    });
    return __singletion;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        
        self.viewNameArray = [NSArray arrayWithObjects:@"全部", @"要闻", @"动态", @"新品", @"竞品", @"其他", nil];
        self.contentSize = CGSizeMake(320*[viewNameArray count], [Globle shareInstance].globleHeight-44);
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        userContentOffsetX = 0;
        
        [self initWithViews];
    }
    return self;
}

- (void)initWithViews
{
    for (int i = 0; i < [viewNameArray count]; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0+320*i, 0, 320, [Globle shareInstance].globleHeight-44)];
        label.text = [NSString stringWithFormat:@"%@",[viewNameArray objectAtIndex:i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:50.0];
        [self addSubview:label];
        //[label release];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    userContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (userContentOffsetX < scrollView.contentOffset.x) {
        isLeftScroll = YES;
    }
    else {
        isLeftScroll = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];
    
//    if (isLeftScroll) {
//        if (scrollView.contentOffset.x <= 320*3) {
//            [[TopScrollView shareInstance] setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
//        else {
//            [[TopScrollView shareInstance] setContentOffset:CGPointMake((POSITIONID-4)*64+45, 0) animated:YES];
//        }
//        
//    }
//    else {
//        if (scrollView.contentOffset.x >= 320*3) {
//            [[TopScrollView shareInstance] setContentOffset:CGPointMake(2*64+45, 0) animated:YES];
//        }
//        else {
//            [[TopScrollView shareInstance] setContentOffset:CGPointMake(POSITIONID*64, 0) animated:YES];
//        }
//    }
}

- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    [[TopScrollView shareInstance] setButtonUnSelect];
    [TopScrollView shareInstance].scrollViewSelectedChannelID = POSITIONID+100;
    [[TopScrollView shareInstance] setButtonSelect];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
