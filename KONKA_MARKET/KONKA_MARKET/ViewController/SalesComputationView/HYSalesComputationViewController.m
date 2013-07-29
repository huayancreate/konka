//
//  HYSalesComputationViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-17.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYSalesComputationViewController.h"
#import "WSPieChartWithMotionView.h"
#import "WSChartObject.h"

@interface HYSalesComputationViewController ()


@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property(nonatomic,strong) UIImage *selectImg;
@property(nonatomic,strong) UIImage *unselectImg;
@property (nonatomic, strong) NSMutableDictionary *pieData;
@property (nonatomic, strong) NSMutableDictionary *pieData2;
@property (nonatomic, strong) WSPieChartWithMotionView *pieChart;


@end

@implementation HYSalesComputationViewController
@synthesize topTableView;
@synthesize salesMoney;
@synthesize salesNum;
@synthesize dateBtn;
@synthesize tableViewCell;
@synthesize dateLabel;
@synthesize uibgLabel;
@synthesize pieData,pieData2,pieChart;
@synthesize chartView;


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
    topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -8, 320, 56) style:UITableViewStyleGrouped];
    
    topTableView.delegate = self;
    topTableView.dataSource = self;
    
    UIView *tempView = [[UIView alloc] init];
    
    topTableView.scrollEnabled = NO;
    
    [topTableView setBackgroundView:tempView];
    
    [self.view addSubview:topTableView];
    
    
    salesNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 46, 125, 40)];
    salesNum.text = @"销售总数量0台";
    salesNum.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:salesNum];
    
    salesMoney = [[UILabel alloc] initWithFrame:CGRectMake(185, 46, 125, 40)];
    salesMoney.text = @"销售总金额0元";
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
    
    
    
    //TODO PLOT
    [self createPieChart];
    
}

- (void)createPieChart
{
    NSMutableArray *arr = [self createPieData];
    NSDictionary *colorDict = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor redColor],@"Liverpool",
                               [UIColor purpleColor],@"MU",
                               [UIColor greenColor],@"Chelsea",
                               [UIColor orangeColor],@"ManCity",
                               [UIColor yellowColor],@"RealMadri",
                               [UIColor brownColor],@"Barcelona",
                               [UIColor blueColor],@"ACMilan",nil];
    
    pieChart = [[WSPieChartWithMotionView alloc] initWithFrame:CGRectMake(0, 0, 280, 280)];
    pieChart.touchEnabled = YES;
    pieChart.openEnabled = YES;
    pieChart.showShadow = YES;
    pieChart.hasLegends = NO;
    [pieChart drawChart:arr withColor:colorDict];
    pieChart.backgroundColor = [UIColor clearColor];
    [self.chartView addSubview:pieChart];
    [self.chartView setBackgroundColor:[UIColor clearColor]];
}

- (NSMutableArray*)createPieData
{
    WSChartObject *lfcObj = [[WSChartObject alloc] init];
    lfcObj.name = @"Liverpool";
    lfcObj.pieValue = arc4random() % 500+10;
    WSChartObject *chObj = [[WSChartObject alloc] init];
    chObj.name = @"Chelsea";
    chObj.pieValue = arc4random() % 500 + 140;
    WSChartObject *muObj = [[WSChartObject alloc] init];
    muObj.name = @"MU";
    muObj.pieValue = arc4random() % 300 + 30;
    WSChartObject *mcObj = [[WSChartObject alloc] init];
    mcObj.name = @"ManCity";
    mcObj.pieValue = arc4random() % 400 + 150;
    WSChartObject *rmObj = [[WSChartObject alloc] init];
    rmObj.name = @"RealMadri";
    rmObj.pieValue = arc4random() % 400 + 50;
    WSChartObject *bcObj = [[WSChartObject alloc] init];
    bcObj.name = @"Barcelona";
    bcObj.pieValue = arc4random() % 400 + 200;
    WSChartObject *acObj = [[WSChartObject alloc] init];
    acObj.name = @"ACMilan";
    acObj.pieValue = arc4random() % 400 + 100;
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:lfcObj,chObj,muObj,mcObj,rmObj,bcObj,acObj, nil];
    return arr;
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
    self.dateLabel.text = [super getUpMonthDate:self.dateLabel.text];
}

-(IBAction)downMoth:(id)sender
{
    self.dateLabel.text = [super getDownMonthDate:self.dateLabel.text];
    
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
    [calendar removeFromSuperview];
}


@end
