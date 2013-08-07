//
//  HYSystemHelpViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-8-7.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYSystemHelpViewController : HYBaseViewController<UIScrollViewDelegate>

@property (strong,nonatomic) IBOutlet UIScrollView *uiAdvLogoScrollView;
@property (strong,nonatomic)NSMutableArray *slideImages;
@property (strong,nonatomic)UIPageControl *pageControl;

@end
