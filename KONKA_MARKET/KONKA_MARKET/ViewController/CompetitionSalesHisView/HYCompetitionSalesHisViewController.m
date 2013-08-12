//
//  HYCompetitionSalesHisViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-8-7.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYCompetitionSalesHisViewController.h"

@interface HYCompetitionSalesHisViewController ()

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property(nonatomic, strong) JSONDecoder* decoder;
@property(nonatomic, strong) NSString *currentDate;

@end

@implementation HYCompetitionSalesHisViewController
@synthesize topTableView;
@synthesize salesMoney;
@synthesize salesNum;
@synthesize downTableView;
@synthesize dateBtn;
@synthesize tableViewCell;
@synthesize decoder;
@synthesize uiCellLabelModelName;
@synthesize uiCellLabelNum;
@synthesize uiCellLabelPrice;
@synthesize uiCellLabelStoreName;
@synthesize uiCellLabelTime;
@synthesize currentDate;
@synthesize dateLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{[super viewDidLoad];
    decoder = [[JSONDecoder alloc] init];    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 22, 111, 19)];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    
    currentDate = [super getNowDate];
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    
    [self getHisDataByStartTime:[super getFirstDayFromMoth:currentDate] endTime:[super getLastDayFromMoth:currentDate]];
    
    // Do any additional setup after loading the view from its nib.
    topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -8, 320, 56) style:UITableViewStyleGrouped];
    
    topTableView.delegate = self;
    topTableView.dataSource = self;
    
    UIView *tempView = [[UIView alloc] init];
    
    [topTableView setBackgroundView:tempView];
    
    topTableView.scrollEnabled = NO;
    
    [topTableView addSubview:dateLabel];
    
    [self.view addSubview:topTableView];
    
    
    salesNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 145, 40)];
    salesNum.text = @"销售总数量0台";
    salesNum.font = [UIFont boldSystemFontOfSize:12];
    salesNum.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:salesNum];
    
    salesMoney = [[UILabel alloc] initWithFrame:CGRectMake(150, 45, 160, 40)];
    salesMoney.font = [UIFont boldSystemFontOfSize:12];
    salesMoney.text = @"销售总金额0元";
    [self.view addSubview:salesMoney];
    salesMoney.backgroundColor = [UIColor clearColor];
    
    downTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, 320, 300) style:UITableViewStyleGrouped];
    downTableView.scrollEnabled = YES;
    
    downTableView.delegate = self;
    
    downTableView.dataSource = self;
    
    UIView *temp = [[UIView alloc] init];
    [downTableView setBackgroundView:temp];
    
    [self.view addSubview:downTableView];
    
    self.uibgLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHandle:)];
    [self.uibgLabel addGestureRecognizer:gesture];
    
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
    
    if (tableView == topTableView)
    {
        return 1;
    }
    if (tableView == downTableView){
        return [self.userLogin.salesRegisterList count];
    }
    return 0;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == topTableView){
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
    
    if (tableView == downTableView) {
        static NSString *SectionTableMyTag=@"CellCompetitionSalesHisIdentifier";
        UITableViewCell *cell = nil;
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYCompetitionSalesHisTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.userInteractionEnabled = NO; 
        NSDictionary *dic = [self.userLogin.salesRegisterList objectAtIndex:indexPath.row];
        uiCellLabelStoreName.text = [dic objectForKey:@"dept_name"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        uiCellLabelNum.text = [numberFormatter stringFromNumber:[dic objectForKey:@"num"]];
        uiCellLabelPrice.text = [numberFormatter stringFromNumber:[dic objectForKey:@"price"]];
        uiCellLabelTime.text = [dic objectForKey:@"report_time"];
        NSDictionary *tempdic = [dic objectForKey:@"map"];
        NSString *tempname = [tempdic objectForKey:@"brand_name"];
        uiCellLabelModelName.text = [tempname stringByAppendingString:[dic objectForKey:@"model_id"]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 70;
}

-(void) getHisDataByStartTime:(NSString *)startTime endTime:(NSString *) endTime
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"GetHis",@"method",self.userLogin.user_name,@"username",self.userLogin.password,@"userpass",@"6",@"type",startTime,@"startime",endTime,@"endtime", @"1" ,@"status",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:LoadDataApi]];
    
    NSLog(@"GetHis params %@", params);
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}

-(void) endRequest:(NSString *)msg
{
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *json = [decoder objectWithData:data];
    
    if ([json count] == 0)
    {
        salesNum.text = @"销售总数量0台";
        salesMoney.text = @"销售总金额0元";
        [self.userLogin.salesRegisterList removeAllObjects];
        [downTableView reloadData];
        [SVProgressHUD dismiss];
        return;
    }
    
    NSLog(@"json count %d" , [json count]);
    [self calNumAndPrice:json];
    
    
    self.userLogin.salesRegisterList = [[NSMutableArray alloc] initWithArray:json];
    [downTableView reloadData];
    
    NSLog(@"self.userLogin.salesAllNum ,%@",self.userLogin.salesAllNum );
    
    salesNum.text = self.userLogin.salesAllNum;
    salesMoney.text = self.userLogin.salesAllPrice;
    
    
    [SVProgressHUD dismiss];
    
}

-(void) calNumAndPrice:(NSArray *)json
{
    NSNumber *allNum = [[NSNumber alloc] initWithInt:0];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    NSDecimalNumber *allPrice = [[NSDecimalNumber alloc] initWithDouble:0];
    for (NSDictionary *dic in json) {
        NSNumber *num = [dic objectForKey:@"num"];
        NSLog(@"[num intValue] %d" , [num intValue]);
        NSNumber *price = [dic objectForKey:@"price"];
        allNum = [NSNumber numberWithInt:[allNum intValue] + [num intValue]];
        NSString *strPrice = [nf stringFromNumber:price];
        NSDecimalNumber *tempPrice = [NSDecimalNumber decimalNumberWithString:strPrice];
        allPrice = [allPrice decimalNumberByAdding:tempPrice];
    }
    NSString *preNum = @"销售总数量";
    NSString *prePrice = @"销售总金额";
    
    //    string = [string1 stringByAppendingString:string2];
    self.userLogin.salesAllNum = [preNum stringByAppendingString:[allNum stringValue]];
    self.userLogin.salesAllNum = [self.userLogin.salesAllNum stringByAppendingString:@"台"];
    //  [self.userLogin.salesAllNum stringByAppendingString:@"台"];
    NSLog(@"self.userLogin.salesAllNum ,%@" ,self.userLogin.salesAllNum);
    
    self.userLogin.salesAllPrice = [prePrice stringByAppendingString:[NSString stringWithFormat:@"%.2f", [allPrice doubleValue]]];
    self.userLogin.salesAllPrice = [self.userLogin.salesAllPrice stringByAppendingString:@"元"];
    
}


-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [super errorMsg:msg];
}

-(IBAction)upMoth:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = [super getUpMonthDate:self.dateLabel.text];
    self.dateLabel.text = [super getUpMonthDate:self.dateLabel.text];
    [self getHisDataByStartTime:[super getFirstDayFromMoth:currentDate] endTime:[super getLastDayFromMoth:currentDate]];
    
}

-(IBAction)downMoth:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = [super getDownMonthDate:self.dateLabel.text];
    self.dateLabel.text = [super getDownMonthDate:self.dateLabel.text];
    [self getHisDataByStartTime:[super getFirstDayFromMoth:currentDate] endTime:[super getLastDayFromMoth:currentDate]];
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
    [self getHisDataByStartTime:[super getFirstDayFromMoth:currentDate] endTime:[super getLastDayFromMoth:currentDate]];
    NSLog(@"currentDate ,%@" , currentDate);
    [calendar removeFromSuperview];
}
@end
