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
//@property (nonatomic, strong) NSMutableDictionary *pieData;
//@property (nonatomic, strong) NSMutableDictionary *pieData2;
//@property (nonatomic, strong) WSPieChartWithMotionView *pieChart;


@end

@implementation HYSalesComputationViewController
@synthesize topTableView;
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
    
    // Do any additional setup after loading the view from its nib.
    self.type = @"1";
    
    decoder = [[JSONDecoder alloc] init];
    pieChart = [[CPTPieChart alloc] init];
    
    self.pieData = [[NSMutableArray alloc] init];
    self.labelArray = [[NSMutableArray alloc] init];
    
    currentDate = [super getNowDate];
    
    topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -8, 320, 56) style:UITableViewStyleGrouped];
    
    topTableView.delegate = self;
    topTableView.dataSource = self;
    
    UIView *tempView = [[UIView alloc] init];
    
    topTableView.scrollEnabled = NO;
    
    [topTableView setBackgroundView:tempView];
    
    [self.view addSubview:topTableView];
    
    
    salesNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 145, 40)];
    salesNum.text = @"销售总数量0台";
    salesNum.font = [UIFont boldSystemFontOfSize:12];
    salesNum.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:salesNum];
    
    salesMoney = [[UILabel alloc] initWithFrame:CGRectMake(150, 45, 160, 40)];
    salesMoney.text = @"销售总金额0元";
    salesMoney.font = [UIFont boldSystemFontOfSize:12];
    [self.view addSubview:salesMoney];
    salesMoney.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:salesMoney];
    
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
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    
    //TODO PLOT
    graph = [[CPTXYGraph alloc] initWithFrame:self.chartView.frame];
    graph.delegate = self;
    self.chartView.hostedGraph = graph;
    
    [self getLoadDataStartTime:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
    
    
    
    [self createPie];
}

-(void) getLoadDataStartTime:(NSString *)starttime EndTime:(NSString *)endtime
{
    //TODO 获取数据
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name,@"username",self.userLogin.password,@"userpass",@"GetStatistic",@"method",self.type,@"type",starttime,@"starttime",endtime,@"endtime",nil];
    
    
    NSLog(@"submit params %@", [HYAppUtily stringOutputForDictionary:params]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:DataStatisticApi]];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}

-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [super alertMsg:@"网络出现问题！" forTittle:@"消息"];
}

-(void) endRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    if ([self.type isEqualToString:@"1"] || [self.type isEqualToString:@"2"])
    {
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *json = [decoder objectWithData:data];
        
        if ([json count] == 0)
        {
            salesNum.text = @"销售总数量0台";
            salesMoney.text = @"销售总金额0元";
            [SVProgressHUD dismiss];
            return;
        }
        int count = 0;
        double count1 = 0.0;
        //[graph removePlot:pieChart];
        [self.pieData removeAllObjects];
        [self.labelArray removeAllObjects];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in json)
        {
            NSArray *arr = [dic objectForKey:@"data"];
            [self.labelArray addObject:[dic objectForKey:@"label"]];
            for(NSArray *ar in arr) {
                NSNumber *temp = ar[0];
                NSNumber *temp1 = ar[1];
                count = count + [temp intValue];
                count1 = count1 + [temp1 doubleValue];
                [tempArr addObject:temp];
            }
        }
        for (NSNumber *nu in tempArr) {
            NSString *tempcount = [nu stringValue];
           //[self.pieData addObject:[NSNumber numberWithDouble: (tempcount / count) * 100]];
            NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:tempcount];
            NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d",count]];
            NSDecimalNumber *product = [multiplierNumber decimalNumberByDividingBy:multiplicandNumber];
            NSString *objA = [NSString stringWithFormat:@"%.1f", [product doubleValue] * 100];
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            NSLog(@"objA %@",objA);
            NSNumber *nud = [nf numberFromString:objA];
            [self.pieData addObject:[NSNumber numberWithDouble:[nud doubleValue]]];
        }
        NSString *preNum = @"销售总数量";
        NSString *prePrice = @"销售总金额";
        preNum = [preNum stringByAppendingString:[NSString stringWithFormat:@"%d",count]];
        preNum = [preNum stringByAppendingString:@"台"];
        
        prePrice = [prePrice stringByAppendingString:[NSString stringWithFormat:@"%.2f",count1]];
        prePrice = [prePrice stringByAppendingString:@"元"];
        salesNum.text = preNum;
        salesMoney.text = prePrice;
        
        [graph reloadData];
    }
}


-(void)createPie
{
    pieChart.delegate = self;
    pieChart.dataSource = self;
    pieChart.pieRadius = 100.0;
    pieChart.identifier = @"PieChart1";
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionCounterClockwise;
    [self.chartView setAllowPinchScaling:YES];
    [graph addPlot:pieChart];
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
    
    self.type = @"1";
    
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    [self getLoadDataStartTime:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
    
    [graph reloadData];
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
    
    self.type = @"2";
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    
    [self getLoadDataStartTime:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
    
    [graph reloadData];
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

-(IBAction)upMoth:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = [super getUpMonthDate:self.dateLabel.text];
    self.dateLabel.text = [super getUpMonthDate:self.dateLabel.text];
    [self getLoadDataStartTime:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
    
}

-(IBAction)downMoth:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = [super getDownMonthDate:self.dateLabel.text];
    self.dateLabel.text = [super getDownMonthDate:self.dateLabel.text];
    [self getLoadDataStartTime:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
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
    [self getLoadDataStartTime:[super getFirstDayFromMoth:currentDate] EndTime:[super getLastDayFromMoth:currentDate]];
    NSLog(@"currentDate ,%@" , currentDate);
    [calendar removeFromSuperview];
}


@end
