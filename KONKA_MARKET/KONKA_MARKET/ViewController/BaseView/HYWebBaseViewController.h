//
//  HYWebBaseViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-8-8.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYWebBaseViewController : HYBaseViewController<UIWebViewDelegate, UIScrollViewDelegate, EGORefreshTableHeaderDelegate>
{
    //下拉视图
    EGORefreshTableHeaderView * _refreshHeaderView;
    //刷新标识，是否正在刷新过程中
    BOOL _reloading;
}

@property(weak, nonatomic) IBOutlet UIWebView *uiWebView;
@property(strong, nonatomic) NSString  *link_url;
-(void) loadPage;

@end
