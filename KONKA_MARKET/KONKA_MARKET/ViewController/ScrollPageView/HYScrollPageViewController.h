//
//  HYScrollPageViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-28.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "SliderPageControl.h"

@interface HYScrollPageViewController : HYBaseViewController<SliderPageControlDelegate, UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    NSMutableArray *demoContent;
    SliderPageControl *sliderPageControl;
    BOOL pageControlUsed;
}

@property (nonatomic, retain) SliderPageControl *sliderPageControl;
@property (nonatomic, retain) NSMutableArray *demoContent;
@property (nonatomic, retain) UIScrollView *scrollView;

- (void)slideToCurrentPage:(bool)animated;
- (void)changeToPage:(int)page animated:(BOOL)animated;

@end
