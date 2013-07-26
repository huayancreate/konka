//
//  HYSalesRegistrationViewViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-16.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYSalesRegistrationViewController.h"

@interface HYSalesRegistrationViewController ()

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property(nonatomic, strong) UIImage *unRegisterImg;
@property(nonatomic, strong) UIImage *RegisterImg;

@end

@implementation HYSalesRegistrationViewController
@synthesize topTableView;
@synthesize salesMoney;
@synthesize salesNum;
@synthesize downTableView;
@synthesize dataItems;
@synthesize dateBtn;
@synthesize tableViewCell;
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
{
    [super viewDidLoad];
    //dataItems=[[NSMutableArray alloc]initWithObjects:@"中国",@"美国",@"日本",@"美国",@"日本",@"美国",@"日本",@"美国",@"日本",@"美国",@"日本",@"美国",@"日本",@"美国",@"日本",@"美国",@"日本",@"美国",@"日本",nil];
    
    
    // Do any additional setup after loading the view from its nib.
    topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -8, 320, 56) style:UITableViewStyleGrouped];
    
    topTableView.delegate = self;
    topTableView.dataSource = self;
    
    UIView *tempView = [[UIView alloc] init];
    
    [topTableView setBackgroundView:tempView];
    
    topTableView.scrollEnabled = NO;
    
    [self.view addSubview:topTableView];
    
    
    salesNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 125, 40)];
    salesNum.text = @"销售总数量0台";
    salesNum.backgroundColor = [UIColor clearColor];

    
    [self.view addSubview:salesNum];
    
    salesMoney = [[UILabel alloc] initWithFrame:CGRectMake(185, 45, 125, 40)];
    salesMoney.text = @"销售总金额0元";
    [self.view addSubview:salesMoney];
    salesMoney.backgroundColor = [UIColor clearColor];
    
    downTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, 320, 280) style:UITableViewStyleGrouped];
    downTableView.scrollEnabled = YES;
    
    downTableView.delegate = self;
    
    downTableView.dataSource = self;
    
    UIView *temp = [[UIView alloc] init];
    [downTableView setBackgroundView:temp];
    
    [self.view addSubview:downTableView];
    
    self.unRegisterImg = [UIImage imageNamed:@"sales_no_reg.png"];
    self.RegisterImg = [UIImage imageNamed:@"sales_reg_all.png"];
    
    [self.unRegistrationBtn setBackgroundImage:self.RegisterImg forState:UIControlStateNormal];
    [self.registrationBtn setBackgroundImage:self.unRegisterImg forState:UIControlStateNormal];
    //[self.unRegistrationBtn setBackgroundColor:[UIColor blueColor]];
    //[self.unRegistrationBtn.titleLabel setTextColor:[UIColor blackColor]];
    //[self.registrationBtn.titleLabel setTextColor:[UIColor blackColor]];
}

-(IBAction)unRegistrationAction:(id)sender
{
    [self.unRegistrationBtn setBackgroundImage:self.RegisterImg forState:UIControlStateNormal];
    [self.registrationBtn setBackgroundImage:self.unRegisterImg forState:UIControlStateNormal];
//    [self.unRegistrationBtn setBackgroundColor:[UIColor blueColor]];
//    [self.registrationBtn.titleLabel setTextColor:[UIColor blackColor]];
//    [self.unRegistrationBtn.titleLabel setTextColor:[UIColor blackColor]];
//    [self.registrationBtn setBackgroundColor:[UIColor clearColor]];
}

-(IBAction)registrationAction:(id)sender
{
    [self.unRegistrationBtn setBackgroundImage:self.unRegisterImg forState:UIControlStateNormal];
    [self.registrationBtn setBackgroundImage:self.RegisterImg forState:UIControlStateNormal];
//    [self.registrationBtn setBackgroundColor:[UIColor blueColor]];
//    [self.unRegistrationBtn.titleLabel setTextColor:[UIColor blackColor]];
//    [self.registrationBtn.titleLabel setTextColor:[UIColor blackColor]];
//    [self.unRegistrationBtn setBackgroundColor:[UIColor clearColor]];
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
        return 0;
        //return [dataItems count];
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
        static NSString *SectionTableMyTag=@"dong";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SectionTableMyTag];
        //如果当前cell没被实例(程序一开始就会运行下面的循环，直到屏幕上所显示的单元格格全被实例化了为止，没有显示在屏幕上的单元格将会根据定义好的标记去寻找可以重用的空间来存放自己的值)
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SectionTableMyTag];
        }
        NSUInteger row=[indexPath row];
        cell.textLabel.text=[dataItems objectAtIndex:row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == downTableView){
        [super alertMsg:[dataItems objectAtIndex:indexPath.row] forTittle:@"消息"];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }

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
