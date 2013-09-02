//
//  HYOAApprovalListViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-8-15.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBackViewController.h"

@interface HYOAApprovalListViewController : HYBackViewController<UIWebViewDelegate, UIScrollViewDelegate, EGORefreshTableHeaderDelegate> {
    //下拉视图
    EGORefreshTableHeaderView * _refreshHeaderView;
    //刷新标识，是否正在刷新过程中
    BOOL _reloading;
}

@property (strong, nonatomic) IBOutlet UIWebView *uiWebView;
@property (nonatomic, strong) NSMutableURLRequest *didRequest;
@property (nonatomic, strong) NSMutableURLRequest *detailRequest;
@property (nonatomic, strong) HYBackViewController *backView;


@end
