//
//  WZGuideViewController.h
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseViewController.h"

@interface WZGuideViewController : HYBaseViewController<UIScrollViewDelegate>
{
    BOOL _animating;
    
    UIScrollView *_pageScroll;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL animating;

@property (nonatomic, strong) UIScrollView *pageScroll;

@property (nonatomic,strong) UINavigationController *navController;

+ (WZGuideViewController *)sharedGuide;

+ (void)show;
+ (void)hide;

@end
