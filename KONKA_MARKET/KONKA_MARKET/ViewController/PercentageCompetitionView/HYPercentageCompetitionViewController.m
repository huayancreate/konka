//
//  HYPercentageCompetitionViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-17.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYPercentageCompetitionViewController.h"
#import "HYPercentageConfigViewController.h"

@interface HYPercentageCompetitionViewController ()

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;


@end

@implementation HYPercentageCompetitionViewController
@synthesize topTableView;
@synthesize tableViewCell;
@synthesize dateBtn;
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
    // Do any additional setup after loading the view from its nib.
    topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -8, 320, 56) style:UITableViewStyleGrouped];
    
    topTableView.delegate = self;
    topTableView.dataSource = self;
    
    UIView *tempView = [[UIView alloc] init];
    [topTableView setBackgroundView:tempView];
    
    topTableView.scrollEnabled = NO;
    
    [self.view addSubview:topTableView];
    
    
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
    self.minimumDate = [self.dateFormatter dateFromString:@"2012年9月"];
    
    self.disabledDates = @[
                           [self.dateFormatter dateFromString:@"2013年5月"],
                           [self.dateFormatter dateFromString:@"2013年6月"],
                           [self.dateFormatter dateFromString:@"2013年7月"]
                           ];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [self.view addSubview:calendar];
    
}

-(IBAction)percentageConfigAction:(id)sender
{
    
    HYPercentageConfigViewController *retailView = [[HYPercentageConfigViewController alloc] init];
    
    [self.navigationController pushViewController:retailView animated:YES];

}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSString *backStr = [[NSString alloc] initWithFormat:[self.dateFormatter stringFromDate:date]];
    self.dateLabel.text = backStr;
    [calendar removeFromSuperview];
}



@end
