//
//  HYHomeViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-3.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYHomeViewController : HYBaseViewController<UIScrollViewDelegate>

-(IBAction)retail:(id)sender;

-(IBAction)sysconfigAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *uiAdvLogoScrollView;
@property (strong,nonatomic)NSMutableArray *slideImages;
@property (strong,nonatomic)UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *linkList;

-(IBAction)oaAction:(id)sender;
-(IBAction)newsAction:(id)sender;
@end
