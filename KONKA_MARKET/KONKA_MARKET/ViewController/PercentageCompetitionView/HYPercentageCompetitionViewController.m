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
@property(nonatomic, strong) NSNumber *flag;
@property(nonatomic, strong) JSONDecoder* decoder;
@property(nonatomic, strong) NSMutableArray *cellPercent;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSString *currentDate;
@property(nonatomic, strong) HYCalculatePercentage *hyc;


@end

@implementation HYPercentageCompetitionViewController
@synthesize topTableView;
@synthesize tableViewCell;
@synthesize dateBtn;
@synthesize downLoadTabelView;
@synthesize dateLabel;
@synthesize uiNumLabel;
@synthesize uiPercentageLabel;
@synthesize uiPriceLabel;
@synthesize decoder;
@synthesize currentDate;
@synthesize hyc;


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
    
    self.flag = [[NSNumber alloc] initWithInt:0];
    
    decoder = [[JSONDecoder alloc] init];
    
    self.cellPercent = [[NSMutableArray alloc] init];
    
    
    topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -8, 320, 56) style:UITableViewStyleGrouped];
    
    topTableView.delegate = self;
    topTableView.dataSource = self;
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 22, 111, 19)];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    
    
    [topTableView addSubview:dateLabel];
    
    UIView *tempView = [[UIView alloc] init];
    [topTableView setBackgroundView:tempView];
    
    UIView *tempView1 = [[UIView alloc] init];
    [downLoadTabelView setBackgroundView:tempView1];
    
    downLoadTabelView.delegate = self;
    downLoadTabelView.dataSource = self;
    
    topTableView.scrollEnabled = NO;
    
    [self.view addSubview:topTableView];

    
    //[self getPeList:self.userLogin.user_id ByFlag:self.flag];
    
    currentDate = [super getNowDate];
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    [self getHisDataByStartTime:[super getFirstDayFromMoth:currentDate] endTime:[super getLastDayFromMoth:currentDate]];
}

-(void) getHisDataByStartTime:(NSString *)startTime endTime:(NSString *) endTime
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"GetHis",@"method",self.userLogin.user_name,@"username",self.userLogin.password,@"userpass",@"1",@"type",startTime,@"startime",endTime,@"endtime", @"1" ,@"status",nil];
    
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
        self.uiNumLabel.text = @"0台";
        self.uiPercentageLabel.text = @"0元";
        self.uiPriceLabel.text = @"0元";
        [hyc.cellPercentList removeAllObjects];
        [downLoadTabelView reloadData];
        [SVProgressHUD dismiss];
        return;
    }
    
    NSLog(@"json count %d" , [json count]);
    
    [self calPercentage:json];
    
    [downLoadTabelView reloadData];
    
    [SVProgressHUD dismiss];
    
}


-(void) calPercentage:(NSArray *)json
{
    hyc = [[HYCalculatePercentage alloc] init];
    hyc.percentList = [[NSMutableArray alloc] init];
    
    hyc.allnum = [[NSNumber alloc] initWithDouble:0];
    hyc.percentPrice = [[NSDecimalNumber alloc] initWithDouble:0];
    hyc.allprice = [[NSDecimalNumber alloc] initWithDouble:0];
    hyc.salesList = json;
    
    NSArray *pelist = [self.kkM getPeListByUserID:self.userLogin.user_id ByType:@"peList" ByFlag:self.flag];
    
    NSArray *temppercentlist = [self.kkM getAllPercentByUserID:self.userLogin.user_id];
    
    for (NSDictionary *dic in pelist)
    {
        NSMutableDictionary *perDic = [[NSMutableDictionary alloc] init];
        NSString *modelName = [self findModelNameByID:[dic objectForKey:@"addon2"]];
        [perDic setValue:modelName forKey:@"modelname"];
        [perDic setValue:[dic objectForKey:@"name"] forKey:@"percent"];
        [perDic setValue:[dic objectForKey:@"addon1"] forKey:@"percentStyle"];
        [hyc.percentList addObject:perDic];
    }
    
    for (NSDictionary *dic in temppercentlist)
    {
        NSMutableDictionary *perDic = [[NSMutableDictionary alloc] init];
        [perDic setValue:[dic objectForKey:@"model_name"] forKey:@"modelname"];
        [perDic setValue:[dic objectForKey:@"percent"] forKey:@"percent"];
        [perDic setValue:[dic objectForKey:@"percent_style"] forKey:@"percentStyle"];
        [hyc.percentList addObject:perDic];
    }
    
    [hyc cal];
    
    [hyc calCellPercentList];
    
    
    self.uiNumLabel.text = [[hyc.allnum stringValue] stringByAppendingString:@"台"];
    self.uiPercentageLabel.text = [[NSString stringWithFormat:@"%.2f", [hyc.percentPrice doubleValue]] stringByAppendingString:@"元"];
    self.uiPriceLabel.text = [[NSString stringWithFormat:@"%.2f", [hyc.allprice doubleValue]] stringByAppendingString:@"元"];
}

-(void) getPeList:(NSNumber *)user_id ByFlag:(NSNumber *)flag
{
    self.userLogin.peList = [self.kkM getPeListByUserID:user_id ByType:@"peList" ByFlag:flag];
    
    for (NSDictionary *dic in self.userLogin.peList)
    {
        NSMutableDictionary *cellDic = [[NSMutableDictionary alloc] init];
        NSString *modelName = [self findModelNameByID:[dic objectForKey:@"addon2"]];
        
        [cellDic setValue:modelName forKey:@"modelName"];
        [cellDic setValue:[dic objectForKey:@"name"] forKey:@"name"];
        if ([[dic objectForKey:@"addon1"] isEqualToString:@"0"])
        {
            [cellDic setValue:@"固定提成" forKey:@"num"];
        }else
        {
            [cellDic setValue:@"按比例提成" forKey:@"num"];
        }
        NSLog(@"downLoadTabelView %@", [cellDic objectForKey:@"modelName"]);
        NSLog(@"downLoadTabelView %@台", [cellDic objectForKey:@"name"]);
        NSLog(@"downLoadTabelView %@", [cellDic objectForKey:@"num"]);
        [self.cellPercent addObject:cellDic];
    }
}

//-(NSString *)findNumber:(NSString *)addon2
//{
//    int i = 0;
//    for (NSDictionary *dic in self.userLogin.peList)
//    {
//        if([addon2 isEqualToString:[dic objectForKey:@"addon2"]])
//        {
//            i = i + 1;
//        }
//    }
//    return [NSString stringWithFormat:@"%d", i];
//}

-(NSString *) findModelNameByID:(NSString *)addon2
{
    return [self.kkM findModelNameByID:self.userLogin.user_id ByName:addon2];
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
    if (tableView == downLoadTabelView){
        return [hyc.cellPercentList count];
    }
    return 1;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == topTableView)
    {
        UITableViewCell *cell = nil;
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TopTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *temp = [[UIView alloc] init];
        [cell setBackgroundView:temp];
        self.dateLabel.text = [super getNowDate];
        return  cell;
    }
    
    if(tableView == downLoadTabelView)
    {
        NSLog(@"downLoadTabelView %d", [self.userLogin.peList count]);
        UITableViewCell *cell = nil;
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYPercentageCompetitionTabelViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"hyc.cellPercentList = %d", [hyc.cellPercentList count]);
        NSDictionary *cellLabel = [hyc.cellPercentList objectAtIndex:indexPath.row];
        NSLog(@"cellPercentList count = ,%d", [hyc.cellPercentList count]);
        self.uiModelLabel.text = [cellLabel objectForKey:@"modelname"];
        NSDecimalNumber *pricedecimal = [cellLabel objectForKey:@"percentage"];
        self.uiPercentage.text = [NSString stringWithFormat:@"%.2f" , [pricedecimal floatValue]];
        self.uiNumber.text = [NSString stringWithFormat:@"%d", [[cellLabel objectForKey:@"num"] intValue]];
        return cell;
    }

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
    
    retailView.title = @"提成设定";
    retailView.userLogin = self.userLogin;
    [self.navigationController pushViewController:retailView animated:YES];

}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSString *backStr = [[NSString alloc] initWithFormat:[self.dateFormatter stringFromDate:date]];
    self.dateLabel.text = backStr;
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = backStr;
    [self getHisDataByStartTime:[super getFirstDayFromMoth:currentDate] endTime:[super getLastDayFromMoth:currentDate]];
    NSLog(@"currentDate ,%@" , currentDate);
    [calendar removeFromSuperview];}

@end
