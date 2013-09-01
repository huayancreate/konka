//
//  HYSalesComputationViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-17.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "TopTableViewCell.h"
#import "CKCalendarView.h"
#import "CorePlot-CocoaTouch.h"

@interface HYSalesComputationViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,TopTabelViewCell,CKCalendarDelegate,CPTPieChartDataSource,CPTPieChartDelegate,CPTBarPlotDataSource,CPTBarPlotDelegate,UIWebViewDelegate>
{
    CPTXYGraph * graph;
	NSMutableArray *pieData;
    CPTXYGraph * graph1;
    NSMutableArray *samples;
}
@property(readwrite, retain, nonatomic) NSMutableArray *pieData;
@property (nonatomic,retain) CPTXYGraph * graph;

@property (nonatomic,strong) UITableView *topTableView;

@property (nonatomic,strong) UITableView *topTableView1;

@property (nonatomic,strong) UILabel *salesNum;

@property (nonatomic,strong) UILabel *salesMoney;

@property (strong, nonatomic) IBOutlet UIButton *uiSizeBtn;
@property (strong, nonatomic) IBOutlet UIButton *uiModelBtn;
@property (strong, nonatomic) IBOutlet UIButton *uiYearsBtn;
@property (strong, nonatomic) IBOutlet UIImageView *uibgLabel;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *chartView;

-(IBAction)sizeAction:(id)sender;

-(IBAction)modelAction:(id)sender;

-(IBAction)yearsAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *uiWebView;

@property (nonatomic,strong) NSString *jsonData;

@end
