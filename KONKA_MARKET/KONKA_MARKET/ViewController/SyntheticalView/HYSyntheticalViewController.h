//
//  HYSyntheticalViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-11-15.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBackViewController.h"

@interface HYSyntheticalViewController : HYBackViewController<UIWebViewDelegate, UIScrollViewDelegate, EGORefreshTableHeaderDelegate> {
    //下拉视图
    EGORefreshTableHeaderView * _refreshHeaderView;
    //刷新标识，是否正在刷新过程中
    BOOL _reloading;
}

@property (strong, nonatomic) IBOutlet UIWebView *uiWebView;
@property (nonatomic, strong) NSMutableURLRequest *didRequest;
@property (nonatomic, strong) NSMutableURLRequest *detailRequest;
@property (nonatomic, strong) HYBackViewController *backView;
@property (weak, nonatomic) IBOutlet UIButton *btnDay;
@property (weak, nonatomic) IBOutlet UIButton *btnMonth;

@property(nonatomic,strong) UIImage *selectImg;
@property(nonatomic,strong) UIImage *unselectImg;
- (IBAction)dayAction:(id)sender;
- (IBAction)monthAction:(id)sender;

@end