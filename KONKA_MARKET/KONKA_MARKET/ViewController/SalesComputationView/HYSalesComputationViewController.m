//
//  HYSalesComputationViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-17.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYSalesComputationViewController.h"
//#import "WSPieChartWithMotionView.h"
//#import "WSChartObject.h"

@interface HYSalesComputationViewController ()


@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property(nonatomic,strong) UIImage *selectImg;
@property(nonatomic,strong) UIImage *unselectImg;
@property(nonatomic,strong) NSString *type;
@property(nonatomic, strong) NSString *currentDate;
@property(nonatomic, strong) JSONDecoder* decoder;
@property(nonatomic, strong) NSMutableArray *labelArray;
@property(nonatomic, strong) CPTPieChart *pieChart;
@property(nonatomic, strong) CPTBarPlot *barChart;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *dateLabel1;
//@property (nonatomic, strong) NSMutableDictionary *pieData;
//@property (nonatomic, strong) NSMutableDictionary *pieData2;
//@property (nonatomic, strong) WSPieChartWithMotionView *pieChart;


@end

@implementation HYSalesComputationViewController
@synthesize topTableView;
@synthesize topTableView1;
@synthesize salesMoney;
@synthesize salesNum;
@synthesize dateBtn;
@synthesize tableViewCell;
@synthesize dateLabel;
@synthesize uibgLabel;
//@synthesize pieData,pieData2,pieChart;
@synthesize chartView;
@synthesize graph,pieData;
@synthesize type;
@synthesize currentDate;
@synthesize decoder;
@synthesize labelArray;
@synthesize pieChart;
@synthesize dateLabel1;
@synthesize barChart;
@synthesize jsonData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[super someButton] addTarget:self action:@selector(backButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
    self.type = @"2";
   
    
    decoder = [[JSONDecoder alloc] init];
    pieChart = [[CPTPieChart alloc] init];
    
    self.pieData = [[NSMutableArray alloc] init];
    self.labelArray = [[NSMutableArray alloc] init];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 22, 111, 19)];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    
    dateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(130, 22, 111, 19)];
    [dateLabel1 setBackgroundColor:[UIColor clearColor]];
    
    currentDate = [super getNowDate];
    
    topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -8, 320, 56) style:UITableViewStyleGrouped];
    
    topTableView.delegate = self;
    topTableView.dataSource = self;
    
    [topTableView addSubview:dateLabel];
    
    UIView *tempView = [[UIView alloc] init];
    
    topTableView.scrollEnabled = NO;
    
    [topTableView setBackgroundView:tempView];
    
    [self.view addSubview:topTableView];
    
    topTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, -8, 320, 56) style:UITableViewStyleGrouped];
    
    dateLabel1.text = [super getNowYear];
    dateLabel.text = [super getNowDate];
    
    topTableView1.delegate = self;
    topTableView1.dataSource = self;
    [topTableView1 addSubview:dateLabel1];
    
    UIView *tempView1 = [[UIView alloc] init];
    
    topTableView1.scrollEnabled = NO;
    
    [topTableView1 setBackgroundView:tempView1];
    
    salesNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 145, 40)];
    salesNum.text = @"销售总数量0台";
    salesNum.font = [UIFont boldSystemFontOfSize:12];
    salesNum.backgroundColor = [UIColor clearColor];
    
    
    //[self.view addSubview:salesNum];
    
    salesMoney = [[UILabel alloc] initWithFrame:CGRectMake(150, 45, 160, 40)];
    salesMoney.text = @"销售总金额0元";
    salesMoney.font = [UIFont boldSystemFontOfSize:12];
    //[self.view addSubview:salesMoney];
    salesMoney.backgroundColor = [UIColor clearColor];
    
    //[self.view addSubview:salesMoney];
    
    self.unselectImg=[UIImage imageNamed:@"sales_unselect.png"];
    self.selectImg=[UIImage imageNamed:@"sales_select.png"];
    
    [self.uiSizeBtn setBackgroundImage:self.selectImg forState:UIControlStateNormal];
    [self.uiModelBtn setBackgroundImage:self.unselectImg forState:UIControlStateNormal];
    [self.uiYearsBtn setBackgroundImage:self.unselectImg forState:UIControlStateNormal];
    
    
    self.uibgLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHandle:)];
    [self.uibgLabel addGestureRecognizer:gesture];
    
//    [self.uiSizeBtn setBackgroundColor:[UIColor blueColor]];
//    
//    [self.uiSizeBtn.titleLabel setTextColor:[UIColor blackColor]];
//    [self.uiModelBtn.titleLabel setTextColor:[UIColor blackColor]];
//    [self.uiYearsBtn.titleLabel setTextColor:[UIColor blackColor]];
    
    
    
    
//    [self createPieChart];
    //[SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    
    //TODO PLOT
//    graph = [[CPTXYGraph alloc] initWithFrame:self.chartView.frame];
//    graph.delegate = self;
//    self.chartView.hostedGraph = graph;
//    
    //[self getLoadDataStartTime:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
//
//    
//    
//    [self createPie];
    [self.uiWebView setUserInteractionEnabled:YES];
    self.uiWebView.scalesPageToFit = YES;
    [self.uiWebView setBackgroundColor:[UIColor clearColor]];
    [self.uiWebView setOpaque:YES];
    self.uiWebView.delegate = self;
    
    [self loadPage:2];
    
    //[self loadJSTest:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
}


-(void) getLoadDataStartTime:(NSString *)starttime EndTime:(NSString *)endtime
{
    //TODO 获取数据
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name,@"username",self.userLogin.password,@"userpass",@"GetStatistic",@"method",self.type,@"type",starttime,@"startime",endtime,@"endtime",nil];
    
    
    NSLog(@"submit params %@", [HYAppUtily stringOutputForDictionary:params]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:DataStatisticApi]];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}

-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [super successMsg:msg];
}

-(void) endRequest:(NSString *)msg
{
    jsonData = msg;
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *json = [decoder objectWithData:data];
    
    if ([self.type isEqualToString:@"3"])
    {
        if ([json count] == 0)
        {
            salesNum.text = @"销售总数量0台";
            salesMoney.text = @"销售总金额0元";
            [self.pieData removeAllObjects];
            [graph reloadData];
            [SVProgressHUD dismiss];
            jsonData = @"";
            [self.uiWebView stringByEvaluatingJavaScriptFromString:[@"loadchart('" stringByAppendingFormat:@"%@');",jsonData]];
            return;
        }
        int count = 0;
        double count1 = 0.0;
        for (NSDictionary *dic in json)
        {
            NSArray *arr = [dic objectForKey:@"data"];
            [self.labelArray addObject:[dic objectForKey:@"label"]];
            for(NSArray *ar in arr) {
                NSNumber *temp = ar[0];
                NSNumber *temp1 = ar[1];
                count = count + [temp intValue];
                count1 = count1 + [temp1 doubleValue];
            }
        }
        NSString *preNum = @"销售总数量";
        NSString *prePrice = @"销售总金额";
        preNum = [preNum stringByAppendingString:[NSString stringWithFormat:@"%d",count]];
        preNum = [preNum stringByAppendingString:@"台"];
        
        prePrice = [prePrice stringByAppendingString:[NSString stringWithFormat:@"%.2f",count1]];
        prePrice = [prePrice stringByAppendingString:@"元"];
        salesNum.text = preNum;
        salesMoney.text = prePrice;
        [self.uiWebView stringByEvaluatingJavaScriptFromString:[@"loadchart('" stringByAppendingFormat:@"%@');",jsonData]];
        [SVProgressHUD dismiss];
    }
    
    if ([self.type isEqualToString:@"1"] || [self.type isEqualToString:@"2"])
    {
        
        if ([json count] == 0)
        {
            salesNum.text = @"销售总数量0台";
            salesMoney.text = @"销售总金额0元";
            [self.pieData removeAllObjects];
            [graph reloadData];
            [SVProgressHUD dismiss];
            jsonData = @"";
            
            if([self.type isEqualToString:@"2"]){
                [self.uiWebView stringByEvaluatingJavaScriptFromString:[@"loadchart('" stringByAppendingFormat:@"%@',%@);",jsonData,@""]];
            }
            if([self.type isEqualToString:@"1"]){
                [self.uiWebView stringByEvaluatingJavaScriptFromString:[@"loadchart('" stringByAppendingFormat:@"%@');",jsonData]];
            }
            return;
        }
        int count = 0;
        double count1 = 0.0;
        //[graph removePlot:pieChart];
//        [self.pieData removeAllObjects];
//        [self.labelArray removeAllObjects];
//        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in json)
        {
            NSArray *arr = [dic objectForKey:@"data"];
            [self.labelArray addObject:[dic objectForKey:@"label"]];
            for(NSArray *ar in arr) {
                NSNumber *temp = ar[0];
                NSNumber *temp1 = ar[1];
                count = count + [temp intValue];
                count1 = count1 + [temp1 doubleValue];
//                [tempArr addObject:temp];
            }
        }
//        for (NSNumber *nu in tempArr) {
//            NSString *tempcount = [nu stringValue];
//           //[self.pieData addObject:[NSNumber numberWithDouble: (tempcount / count) * 100]];
//            NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:tempcount];
//            NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d",count]];
//            NSDecimalNumber *product = [multiplierNumber decimalNumberByDividingBy:multiplicandNumber];
//            NSString *objA = [NSString stringWithFormat:@"%.1f", [product doubleValue] * 100];
//            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
//            NSLog(@"objA %@",objA);
//            NSNumber *nud = [nf numberFromString:objA];
//            [self.pieData addObject:[NSNumber numberWithDouble:[nud doubleValue]]];
//        }
        NSString *preNum = @"销售总数量";
        NSString *prePrice = @"销售总金额";
        preNum = [preNum stringByAppendingString:[NSString stringWithFormat:@"%d",count]];
        preNum = [preNum stringByAppendingString:@"台"];
        
        prePrice = [prePrice stringByAppendingString:[NSString stringWithFormat:@"%.2f",count1]];
        prePrice = [prePrice stringByAppendingString:@"元"];
        salesNum.text = preNum;
        salesMoney.text = prePrice;
        
        NSString *sumMoney = [NSString stringWithFormat:@"%.2f",count1];
        if([self.type isEqualToString:@"2"]){
            [self.uiWebView stringByEvaluatingJavaScriptFromString:[@"loadchart('" stringByAppendingFormat:@"%@',%@);",jsonData,sumMoney]];
        }
        if([self.type isEqualToString:@"1"]){
            [self.uiWebView stringByEvaluatingJavaScriptFromString:[@"loadchart('" stringByAppendingFormat:@"%@');",jsonData]];
        }
        [SVProgressHUD dismiss];
    }
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.pieData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	return [self.pieData objectAtIndex:index];
}

-(CPTLayer*)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index

{
    CPTTextLayer *label    = [[CPTTextLayer alloc] initWithText:self.labelArray[index]];
    
    CPTMutableTextStyle *textStyle =[label.textStyle mutableCopy];
    
    textStyle.color = [CPTColor lightGrayColor];
    
    label.textStyle = textStyle;
    return label;
    
}

-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)index
{
    //[super alertMsg:@"11" forTittle:@"11"];
    [graph reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 1;
}

-(IBAction)sizeAction:(id)sender{
    
    [self.uiSizeBtn setBackgroundImage:self.selectImg forState:UIControlStateNormal];
    [self.uiModelBtn setBackgroundImage:self.unselectImg forState:UIControlStateNormal];
    [self.uiYearsBtn setBackgroundImage:self.unselectImg forState:UIControlStateNormal];
    
    if ([self.type isEqualToString:@"3"])
    {
        [topTableView1 removeFromSuperview];
        [self.view addSubview:topTableView];
    }
    
    self.type = @"2";
    
    currentDate = self.dateLabel.text;
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    [self loadPage:2];
    
//    if([self.type isEqualToString:@"2"]){
//        NSString *path = [[NSBundle mainBundle]pathForResource:@"mobile_01.html" ofType:nil];
//        [self.uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
//    }
//    [self getLoadDataStartTime:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
//    
//    [graph reloadData];
//    [self.uiSizeBtn setBackgroundColor:[UIColor blueColor]];
//    [self.uiModelBtn setBackgroundColor:[UIColor clearColor]];
//    [self.uiYearsBtn setBackgroundColor:[UIColor clearColor]];
//    
//    
//    [self.uiSizeBtn.titleLabel setTextColor:[UIColor blackColor]];
//    [self.uiModelBtn.titleLabel setTextColor:[UIColor blackColor]];
//    [self.uiYearsBtn.titleLabel setTextColor:[UIColor blackColor]];

    
}

-(IBAction)modelAction:(id)sender{
    [self.uiSizeBtn setBackgroundImage:self.unselectImg forState:UIControlStateNormal];
    [self.uiModelBtn setBackgroundImage:self.selectImg forState:UIControlStateNormal];
    [self.uiYearsBtn setBackgroundImage:self.unselectImg forState:UIControlStateNormal];
    
    if ([self.type isEqualToString:@"3"])
    {
        [topTableView1 removeFromSuperview];
        [self.view addSubview:topTableView];
    }
    
    currentDate = self.dateLabel.text;
    self.type = @"1";
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    //[self getLoadDataStartTime:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
    
    [self loadPage:1];
//    if([self.type isEqualToString:@"3"]){
//        NSString *path = [[NSBundle mainBundle]pathForResource:@"mobile_02.html" ofType:nil];
//        [self.uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
//    }
//    [graph reloadData];
//    [self.uiModelBtn setBackgroundColor:[UIColor blueColor]];
//    [self.uiSizeBtn setBackgroundColor:[UIColor clearColor]];
//    [self.uiYearsBtn setBackgroundColor:[UIColor clearColor]];
//    
//    
//    [self.uiSizeBtn.titleLabel setTextColor:[UIColor blackColor]];
//    [self.uiModelBtn.titleLabel setTextColor:[UIColor blackColor]];
//    [self.uiYearsBtn.titleLabel setTextColor:[UIColor blackColor]];

    
}

-(IBAction)yearsAction:(id)sender{
    
    [self.uiSizeBtn setBackgroundImage:self.unselectImg forState:UIControlStateNormal];
    [self.uiModelBtn setBackgroundImage:self.unselectImg forState:UIControlStateNormal];
    [self.uiYearsBtn setBackgroundImage:self.selectImg forState:UIControlStateNormal];
    
    self.type = @"3";
    
    [self.topTableView removeFromSuperview];
    
    [self.view addSubview:topTableView1];
    
    NSLog(@"self.dateLabel1.text = %@",self.dateLabel1.text);
    NSLog(@"self.dateLabel.text = %@",self.dateLabel.text);
    
    currentDate = self.dateLabel1.text;
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    //[self getLoadDataStartTime:[super getFirstDayFromYear:currentDate] EndTime:[super getLastDayFromYear:currentDate]];
    
    [self loadPage:3];
//    [self.uiYearsBtn setBackgroundColor:[UIColor blueColor]];
//    [self.uiModelBtn setBackgroundColor:[UIColor clearColor]];
//    [self.uiSizeBtn setBackgroundColor:[UIColor clearColor]];
//    
//    [self.uiSizeBtn.titleLabel setTextColor:[UIColor blackColor]];
//    [self.uiModelBtn.titleLabel setTextColor:[UIColor blackColor]];
//    [self.uiYearsBtn.titleLabel setTextColor:[UIColor blackColor]];

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == topTableView)
    {
        static NSString *CustomCellIdentifier =@"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
        if (cell ==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TopTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *temp = [[UIView alloc] init];
        [cell setBackgroundView:temp];
        
        self.dateLabel.text = [super getNowDate];
        return  cell;
    }
    if (tableView == topTableView1)
    {
        static NSString *CustomCellIdentifier =@"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
        if (cell ==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TopTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *temp = [[UIView alloc] init];
        [cell setBackgroundView:temp];
        
        self.dateLabel1.text = [super getNowYear];
        return  cell;
    }
}

-(IBAction)upMoth:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = [super getUpMonthDate:self.dateLabel.text];
    self.dateLabel.text = [super getUpMonthDate:self.dateLabel.text];
    [self getLoadDataStartTime:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
    if([self.type isEqualToString:@"2"]){
        [self loadPage:2];
    }
    if([self.type isEqualToString:@"1"]){
        [self loadPage:1];
    }
    
}

-(IBAction)downMoth:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = [super getDownMonthDate:self.dateLabel.text];
    self.dateLabel.text = [super getDownMonthDate:self.dateLabel.text];
    [self getLoadDataStartTime:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
    if([self.type isEqualToString:@"2"]){
        [self loadPage:2];
    }
    if([self.type isEqualToString:@"1"]){
        [self loadPage:1];
    }
}

-(IBAction)upYear:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = [super getUpYear:self.dateLabel1.text];
    self.dateLabel1.text = [super getUpYear:self.dateLabel1.text];
    [self getLoadDataStartTime:[super getFirstDayFromYear:currentDate] EndTime:[super getLastDayFromYear:currentDate]];
    [self loadPage:3];
    
}

-(IBAction)downYear:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = [super getDownYear:self.dateLabel1.text];
    self.dateLabel1.text = [super getDownYear:self.dateLabel1.text];
    [self getLoadDataStartTime:[super getFirstDayFromYear:currentDate] EndTime:[super getLastDayFromYear:currentDate]];
    [self loadPage:3];
}

-(IBAction)dataPick:(id)sender
{
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy年MM月"];
    self.minimumDate = [self.dateFormatter dateFromString:@"2012年12月"];
    
    //    self.disabledDates = @[
    //                           [self.dateFormatter dateFromString:@"05/01/2013"],
    //                           [self.dateFormatter dateFromString:@"06/01/2013"],
    //                           [self.dateFormatter dateFromString:@"07/01/2013"]
    //                           ];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [self.view addSubview:calendar];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    NSString *backStr = [[NSString alloc] initWithFormat:[self.dateFormatter stringFromDate:date]];
    self.dateLabel.text = backStr;
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = backStr;
    [self getLoadDataStartTime:[super getFirstDayFromYear:currentDate] EndTime:[super getLastDayFromYear:currentDate]];
    NSLog(@"currentDate ,%@" , currentDate);
    [calendar removeFromSuperview];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)_request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"_request.URL.absoluteString %@",_request.URL.absoluteString);

    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if([self.type isEqualToString:@"3"]){
        [self getLoadDataStartTime:[super getFirstDayFromYear:currentDate] EndTime:[super getLastDayFromYear:currentDate]];
    }else{
        [self getLoadDataStartTime:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
    }
}

-(void)loadPage:(int)chartType{
    NSString *path = nil;
    switch (chartType) {
        case 1:
            path = [[NSBundle mainBundle]pathForResource:@"mobile_02.html" ofType:nil];
            [self.uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
            break;
        case 2:
            path = [[NSBundle mainBundle]pathForResource:@"mobile_01.html" ofType:nil];
            [self.uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
            break;
        case 3:
            path = [[NSBundle mainBundle]pathForResource:@"mobile_03.html" ofType:nil];
            [self.uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
            break;
    }
}

@end
