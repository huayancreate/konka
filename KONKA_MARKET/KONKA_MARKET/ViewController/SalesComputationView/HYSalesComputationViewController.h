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
#import "EskBarPlot.h"
#import "EskLinePlot.h"

@interface HYSalesComputationViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,TopTabelViewCell,CKCalendarDelegate,EskBarPlotDelegate, EskLinePlotDelegate>
{
@private
    EskBarPlot *barPlot;
    EskLinePlot *linePlot;
}
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *barCorePlotView;


@property (nonatomic,strong) UITableView *topTableView;

@property (nonatomic,strong) UILabel *salesNum;

@property (nonatomic,strong) UILabel *salesMoney;

@property (strong, nonatomic) IBOutlet UIButton *uiSizeBtn;
@property (strong, nonatomic) IBOutlet UIButton *uiModelBtn;
@property (strong, nonatomic) IBOutlet UIButton *uiYearsBtn;

-(IBAction)sizeAction:(id)sender;

-(IBAction)modelAction:(id)sender;

-(IBAction)yearsAction:(id)sender;

@end
