//
//  HYMobileDataSubmitViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-11-14.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYMobileDataSubmitViewController.h"

#import "HYMobileHistoryViewController.h"
#import "KonkaManager.h"

#define NUMBERS @"0123456789\n"
#define NUMBERSPERIOD @"0123456789xX\n"


@interface HYMobileDataSubmitViewController ()
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;


@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic, strong) UILabel *storeName;
@property (nonatomic, strong) UITextField *memo;
@property (nonatomic, strong) UITextField *saleAllPrice;
@property (nonatomic, strong) UITextField *selectChoice2;
@property (nonatomic, strong) UITextField *salesCount;
@property (nonatomic, strong) UITextField *salesPrice;
@property (nonatomic, strong) UIButton *upDate;
@property (nonatomic, strong) UIButton *downDate;

@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *priceLabel1;
@property (nonatomic, strong) NSString *submitMemo;
//@property (nonatomic, strong) NSString *submitSaleTime;
@property (nonatomic, strong) NSString *submitSelectChoice2;
@property (nonatomic, strong) NSString *submitStoreID;
@property (nonatomic, strong) NSString *submitSalesCount;
@property (nonatomic, strong) NSString *submitSalesPrice;
@property (nonatomic, strong) NSString *submitUpDate;
@property (nonatomic, strong) NSString *submitDownDate;
//@property (nonatomic, strong) NSString *submitAddress;
//@property (nonatomic, strong) NSString *submitMastercode;
@property (nonatomic, strong) NSNumber *dataID;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic) NSInteger *flagTag;

@end

@implementation HYMobileDataSubmitViewController
@synthesize cellLabel;
@synthesize cellTextField;
@synthesize mainTableView;
@synthesize LabelTextTableViewCell;
@synthesize cellImage;
@synthesize cellLabel1;
@synthesize cellLabel2;
@synthesize cellLabel3;
@synthesize dropDownTableView;
@synthesize cellLabel4;
@synthesize selectChoice2 = _textField;
@synthesize autoCompleter = _autoCompleter;
@synthesize storeName;
@synthesize uibgLabel;
@synthesize submitMemo;
//@synthesize submitSaleTime;
@synthesize submitSelectChoice2;
@synthesize submitStoreID;
@synthesize submitSalesCount;
@synthesize submitSalesPrice;
//@synthesize submitRealname;
//@synthesize submitPhonenum;
//@synthesize submitAddress;
//@synthesize submitMastercode;
@synthesize memo;
@synthesize salesCount;
@synthesize salesPrice;
@synthesize saleAllPrice;
@synthesize upDate;
@synthesize downDate;
@synthesize dataID;
@synthesize priceLabel;
@synthesize numLabel;
@synthesize priceLabel1;
@synthesize dateTime;
@synthesize flagTag;
@synthesize submitDownDate;
@synthesize submitUpDate;
@synthesize is_up;

- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.selectChoice2 inViewController:self withOptions:options];
        _autoCompleter.autoCompleteDelegate = self;
    }
    return _autoCompleter;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == dropDownTableView)
    {
        NSDictionary *dic = (NSDictionary *)[self.userLogin.storeList objectAtIndex:indexPath.row];
        NSLog(@"indexPath.row %d", indexPath.row);
        NSLog(@"indexPath.row %@", [dic objectForKey:@"name"]);
        storeName.text = [dic objectForKey:@"name"];
        [dropDownTableView removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[super someButton] addTarget:self action:@selector(backButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
    
    [self getStoreList:self.userLogin.user_id];
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, ([super screenHeight] - 100)) style:UITableViewStyleGrouped];
    mainTableView.scrollEnabled = YES;
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    self.dataID = nil;
    
    [self.view addSubview:mainTableView];
    
    UIView *tempView = [[UIView alloc] init];
    [mainTableView setBackgroundView:tempView];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"right.png"];
    CGRect frameimg = CGRectMake(0, 0, 32, 24);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    
    [someButton addTarget:self action:@selector(submit:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    [self getAllUsualModelNameList:self.userLogin.user_id];
    
    CGRect textFieldRect = CGRectMake(120, 145, 175, 30);
    self.selectChoice2 = [[UITextField alloc] initWithFrame:textFieldRect];
    self.memo = [[UITextField alloc] initWithFrame:textFieldRect];
    self.memo.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.priceLabel1 setBackgroundColor:[UIColor clearColor]];
    self.priceLabel1.text = @"元";
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.priceLabel setBackgroundColor:[UIColor clearColor]];
    self.priceLabel.text = @"元";
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.numLabel setBackgroundColor:[UIColor clearColor]];
    self.numLabel.text = @"台";
    
    self.salesCount = [[UITextField alloc] initWithFrame:CGRectMake(117, 10, 145, 30)];
    self.salesPrice = [[UITextField alloc] initWithFrame:CGRectMake(117, 10, 145, 30)];
    self.salesPrice.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.saleAllPrice = [[UITextField alloc] initWithFrame:CGRectMake(117, 10, 145, 30)];
    self.saleAllPrice.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.upDate = [[UIButton alloc] initWithFrame:CGRectMake(117, 10, 145, 30)];
    [self.upDate setTitle:[super getNowDateYYYYMMDD] forState:UIControlStateNormal];
    [self.upDate addTarget:self action:@selector(dataPick:) forControlEvents:UIControlEventTouchUpInside];
    [self.upDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.upDate.tag = 0;
    
    self.downDate = [[UIButton alloc] initWithFrame:CGRectMake(117, 10, 145, 30)];
    //[self.downDate setTitle:[super getNowDateYYYYMMDD] forState:UIControlStateNormal];
    [self.downDate addTarget:self action:@selector(dataPick:) forControlEvents:UIControlEventTouchUpInside];
    [self.downDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.downDate.tag = 1;
    
    self.salesPrice.delegate = self;
    self.saleAllPrice.delegate = self;
    self.salesCount.delegate = self;
    
    self.salesCount.text = @"1";
    saleAllPrice.text = @"0.0";
    salesPrice.text = @"0.0";
    
    [self.salesCount setKeyboardType:UIKeyboardTypeNumberPad];
    [self.saleAllPrice setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [self.salesPrice setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    [self.memo addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.salesCount addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.salesCount addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.salesPrice addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.salesPrice addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.saleAllPrice addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.saleAllPrice addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.selectChoice2 addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.selectChoice2 addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    CGRect labelFieldRect = CGRectMake(0, 0, 175, 30);
    storeName = [[UILabel alloc] initWithFrame:labelFieldRect];
    
    NSDictionary *dic = [self.userLogin.storeList objectAtIndex:0];
    storeName.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = nil;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeSelectAction:)];
    [storeName addGestureRecognizer:singleTap];
    storeName.text = [dic objectForKey:@"name"];
    [storeName setBackgroundColor:[UIColor clearColor]];
    
    self.uibgLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHandle:)];
    [self.uibgLabel addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHandle:)];
    [self.mainTableView addGestureRecognizer:singleTap1];
    if (self.userLogin.dataSubmit != nil)
    {
        storeName.enabled = false;
        self.selectChoice2.enabled = true;
        salesCount.enabled = true;
        saleAllPrice.enabled = true;
        self.salesPrice.enabled = true;
        self.memo.enabled = true;
        
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setUsesGroupingSeparator:NO];
        storeName.text = [self.userLogin.dataSubmit objectForKey:@"dept_name"];
        
        salesCount.text = [numberFormatter stringFromNumber:[self.userLogin.dataSubmit objectForKey:@"num"]];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        saleAllPrice.text = [numberFormatter stringFromNumber:[self.userLogin.dataSubmit objectForKey:@"price"]];
        NSLog(@"saleAllPrice.text %@",saleAllPrice.text);
        salesPrice.text = [self calPrice];
        self.selectChoice2.text = [self.userLogin.dataSubmit objectForKey:@"model_name"];
        self.dataID = [self.userLogin.dataSubmit objectForKey:@"id"];
        
        NSLog(@"up_date %@",[self.userLogin.dataSubmit objectForKey:@"up_date"]);
        
        NSLog(@"down_date %@",[self.userLogin.dataSubmit objectForKey:@"down_date"]);
        
        [self.upDate setTitle:[self.userLogin.dataSubmit objectForKey:@"up_date"] forState:UIControlStateNormal];
        [self.downDate setTitle:[self.userLogin.dataSubmit objectForKey:@"down_date"] forState:UIControlStateNormal];
        
        //self.upDate.titleLabel.text = [self.userLogin.allDataSubmit objectForKey:@"up_date"];
        //self.downDate.titleLabel.text = [self.userLogin.allDataSubmit objectForKey:@"down_date"];
        
        self.dataID = [self.userLogin.dataSubmit objectForKey:@"id"];
        memo.text = [self.userLogin.dataSubmit objectForKey:@"memo"];
        
        NSLog(@"dataID , %d", [self.dataID intValue]);
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
        self.navigationItem.rightBarButtonItem  = rightButton;
        
        if([is_up isEqualToString:@"0"]){
            salesCount.enabled = false;
            saleAllPrice.enabled = false;
            self.selectChoice2.enabled = false;
            self.memo.enabled = false;
            self.upDate.enabled = false;
            self.downDate.enabled = false;
            someButton.hidden = true;
        }
        else{
            dateTime = [self.userLogin.dataSubmit objectForKey:@"report_date"];
            NSString *date = [super getNowDateYYYYMMDD];
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dataNow = [self.dateFormatter dateFromString:date];
            NSDate *newDate = [super getIntervalDateByDays:2 ByDate:dateTime];
            if ([dataNow compare:newDate] == NSOrderedDescending) { //判断数据是否在2天内
                salesCount.enabled = false;
                //saleAllPrice.enabled = false;
                self.selectChoice2.enabled = false;
                //self.memo.enabled = false;
                self.upDate.enabled = false;
                [self.saleAllPrice setBorderStyle:UITextBorderStyleLine];
                [self.memo setBorderStyle:UITextBorderStyleLine];
                //self.downDate.enabled = false;
            }else{
                self.storeName.enabled = true;
                [self.selectChoice2 setBorderStyle:UITextBorderStyleLine];
                [self.salesCount setBorderStyle:UITextBorderStyleLine];
                [self.salesPrice setBorderStyle:UITextBorderStyleLine];
                [self.saleAllPrice setBorderStyle:UITextBorderStyleLine];
                [self.memo setBorderStyle:UITextBorderStyleLine];
                UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
                self.navigationItem.rightBarButtonItem  = rightButton;
            }
            
        }
    }
    else
    {
        [self.selectChoice2 setBorderStyle:UITextBorderStyleLine];
        [self.salesCount setBorderStyle:UITextBorderStyleLine];
        [self.salesPrice setBorderStyle:UITextBorderStyleLine];
        [self.saleAllPrice setBorderStyle:UITextBorderStyleLine];
        [self.memo setBorderStyle:UITextBorderStyleLine];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
        self.navigationItem.rightBarButtonItem  = rightButton;
    }
}

-(void) getAllUsualModelNameList:(NSNumber *)user_id
{
    self.userLogin.modelNameStoreList = [self.kkM getAllUsualModelNameListByUserID:user_id];
    NSLog(@"getAllModelNameList %d" , [self.userLogin.modelNameStoreList count]);
}

- (void) getStoreList:(NSNumber *)user_id
{
    
    self.userLogin.storeList = [self.kkM getStoreListByUserID:user_id];
}


- (void) submit:(id)sender
{
    //TODO 组装数据
    [SVProgressHUD showWithStatus:@"数据提交中..." maskType:SVProgressHUDMaskTypeGradient];
    
    submitSelectChoice2 = [self.kkM findModelID:self.userLogin.user_id ByName:self.selectChoice2.text];
    
    submitStoreID = [self.kkM findStoreID:self.userLogin.user_id ByName:self.storeName.text];
    
    if (self.memo.text == nil)
    {
        submitMemo = @"";
    }else
    {
        submitMemo = self.memo.text;
    }
    
    if (self.saleAllPrice.text == nil)
    {
        submitSalesPrice = @"";
    }else
    {
        submitSalesPrice = self.saleAllPrice.text;
    }
    
    if (self.salesCount.text == nil)
    {
        submitSalesCount = @"";
    }else
    {
        submitSalesCount = self.salesCount.text;
    }
    submitUpDate = self.upDate.titleLabel.text;
    submitDownDate = self.downDate.titleLabel.text;
    
    NSDate *upDate =[self.dateFormatter dateFromString: submitUpDate];
    NSDate *downDate =[self.dateFormatter dateFromString: submitDownDate];
    if([upDate compare:downDate] == NSOrderedDescending){
        [super errorMsg:@"上样日期不能大于下架日期"];
        return;
    }
    
    NSDictionary *params = nil;
    
    if (self.dataID == nil)
    {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name,@"username",self.userLogin.password,@"userpass",@"DoSubmit04",@"method",submitStoreID,@"store_id",submitMemo,@"memo",submitSalesCount,@"count",submitSalesPrice,@"price",submitSelectChoice2,@"pd_id",submitUpDate,@"up_date",submitDownDate,@"down_date",[super getNowDateYYYYMMDD],@"report_date",nil];
    }else
    {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name,@"username",self.userLogin.password,@"userpass",@"DoSubmit04",@"method",submitStoreID,@"store_id",submitMemo,@"memo",submitSalesCount,@"count",submitSalesPrice,@"price",submitSelectChoice2,@"pd_id",submitUpDate,@"up_date",submitDownDate,@"down_date",self.dataID,@"id",[super getNowDateYYYYMMDD],@"report_date",nil];
    }
    
    NSLog(@"submit params %@", [HYAppUtily stringOutputForDictionary:params]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:DataSubmitApi]];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}


-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [super errorMsg:msg];
}

-(void) endRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    if ([msg isEqualToString:@"success"])
    {
        [super successMsg:@"提交成功"];
        self.selectChoice2.text = nil;
        salesCount.text = @"1";
        saleAllPrice.text = @"0.0";
        salesPrice.text = @"0.0";
        memo.text = nil;
        
        if (self.userLogin.dataSubmit != nil)
        {
            HYMobileHistoryViewController *c = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2];
            NSString *currentDate = c.dateLabel.text;
            [c getHisDataByStartTime:[super getFirstDayFromMoth:currentDate] endTime:[super getLastDayFromMoth:currentDate]];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
        }
        else if (self.userLogin.allDataSubmit != nil)
        {
            HYMobileHistoryViewController *c = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2];
            NSString *currentDate = c.dateLabel.text;
            [c getHisDataByStartTime:[super getFirstDayFromMoth:currentDate] endTime:[super getLastDayFromMoth:currentDate]];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
            //[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
        }
        
    }else
    {
        [super errorMsg:msg];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    //    if (tableView == mainTableView) {
    //        return 2;
    //    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == mainTableView) {
        return 8;
    }
    if(tableView == dropDownTableView)
    {
        return [self.userLogin.storeList count];
    }
    return 5;
}

-(HYTableViewCell *) createTabelViewCellForIndentifier: (NSString *) indentifier NibNamed: (NSString *) nibName tableView:(UITableView *)tableView index:(int) index{
    
    HYTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier: indentifier];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];
    cell = [nib objectAtIndex:index];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == dropDownTableView)
    {
        return 0;
    }
    return 10;
}

-(void)storeSelectAction:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.storeName.enabled)
    {
        return;
    }
    if (dropDownTableView != nil)
    {
        [dropDownTableView removeFromSuperview];
        dropDownTableView = nil;
    }
    dropDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(107, 90, 175, 132) style:UITableViewStylePlain];
    dropDownTableView.scrollEnabled = YES;
    
    dropDownTableView.delegate = self;
    dropDownTableView.dataSource = self;
    [self.view addSubview:dropDownTableView];
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    NSDictionary *dic = nil;
    if (tableView == dropDownTableView)
    {
        dic = (NSDictionary *)[self.userLogin.storeList objectAtIndex:0];
        cell = [tableView dequeueReusableCellWithIdentifier: @"LabelTextCellIdentifier"];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        dic = (NSDictionary *)[self.userLogin.storeList objectAtIndex:indexPath.row];
        self.cellLabel.text = [dic objectForKey:@"name"];
        return cell;
    }
    
    if (tableView == mainTableView) {
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        cell = [self createTabelViewCellForIndentifier:@"DropDownCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        cell.accessoryView = storeName;
                        self.cellLabel4.text = @"门店";
                        return cell;
                        break;
                    case 1:
                        break;
                    case 2:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        cell.accessoryView = self.selectChoice2;
                        self.cellLabel4.text = @"型号";
                        return cell;
                        break;
                    case 3:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        cell.accessoryView = self.upDate;
                        self.cellLabel4.text = @"上样日期";
                        return cell;
                        break;
                    case 4:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        cell.accessoryView = self.downDate;
                        self.cellLabel4.text = @"下架日期";
                        return cell;
                        break;
                    case 5:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        [cell.contentView addSubview:self.salesCount];
                        cell.accessoryView = self.numLabel;
                        self.cellLabel4.text = @"数量";
                        return cell;
                        break;
                        //                    case 6:
                        //                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        //                        [cell.contentView addSubview:self.salesPrice];
                        //                        cell.accessoryView = self.priceLabel1;
                        //                        self.cellLabel4.text = @"单价";
                        //                        return cell;
                        //                        break;
                    case 6:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        [cell.contentView addSubview:self.saleAllPrice];
                        cell.accessoryView = self.priceLabel;
                        self.cellLabel4.text = @"挂牌价";
                        return cell;
                        break;
                    case 7:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        cell.accessoryView = self.memo;
                        self.cellLabel4.text = @"备注";
                        return cell;
                        break;
                        
                }
                break;
        }
        
        if (indexPath.section == 0 && indexPath.row == 1)
        {
            
            UITableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"LabelImageCellIdentifier"];
            if (cell ==nil) {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:1];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.storeName.enabled)
            {
                self.cellImage.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanCamera:)];
                [self.cellImage addGestureRecognizer:singleTap];
            }
            self.cellLabel1.text = @"扫描";
            return cell;
        }
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = NO;
    
    return cell;
}

-(void)scanCamera:(UIGestureRecognizer *)gestureRecognizer
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.wantsFullScreenLayout = NO;
    reader.showsZBarControls = NO;
    
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    [self setOverlayPickerView:reader];
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
}

- (void)setOverlayPickerView:(ZBarReaderViewController *)reader

{
    
    //清除原有控件
    
    for (UIView *temp in [reader.view subviews]) {
        
        for (UIButton *button in [temp subviews]) {
            
            if ([button isKindOfClass:[UIButton class]]) {
                
                [button removeFromSuperview];
                
            }
            
        }
        
        for (UIToolbar *toolbar in [temp subviews]) {
            
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                
                [toolbar setHidden:YES];
                
                [toolbar removeFromSuperview];
                
            }
            
        }
        
    }
    
    //画中间的基准线
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(40, 220, 240, 1)];
    
    line.backgroundColor = [UIColor redColor];
    
    [reader.view addSubview:line];
    
    //最上部view
    
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    
    upView.alpha = 0.3;
    
    upView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:upView];
    
    //用于说明的label
    
    UILabel * labIntroudction= [[UILabel alloc] init];
    
    labIntroudction.backgroundColor = [UIColor clearColor];
    
    labIntroudction.frame=CGRectMake(15, 20, 290, 50);
    
    labIntroudction.numberOfLines=2;
    
    labIntroudction.textColor=[UIColor whiteColor];
    
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    
    [upView addSubview:labIntroudction];
    
    //左侧的view
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 20, 280)];
    
    leftView.alpha = 0.3;
    
    leftView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:leftView];
    
    //右侧的view
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(300, 80, 20, 280)];
    
    rightView.alpha = 0.3;
    
    rightView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:rightView];
    
    //底部view
    
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 120)];
    
    downView.alpha = 0.3;
    
    downView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:downView];
    
    //用于取消操作的button
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    cancelButton.alpha = 0.4;
    
    [cancelButton setFrame:CGRectMake(20, 390, 280, 40)];
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
    
    [reader.view addSubview:cancelButton];
    
}

- (void)dismissOverlayView:(id)sender{
    
    [self dismissModalViewControllerAnimated: YES];
    
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image =
    //[info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    NSString *resultStr=symbol.data;
    if ([resultStr canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
        resultStr = [NSString stringWithCString:[resultStr cStringUsingEncoding: NSShiftJISStringEncoding]  encoding:NSUTF8StringEncoding];
    }
    self.selectChoice2.text = resultStr;
    //[super errorMsg:resultStr];
    [[reader presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return(YES);
}


- (IBAction)hisAction:(id)sender{
    
    if (self.userLogin.dataSubmit != nil)
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
    }else{
        HYMobileHistoryViewController *srView = [[HYMobileHistoryViewController alloc] init];
        srView.userLogin = self.userLogin;
        srView.title = @"样机历史";
        [self.navigationController pushViewController:srView animated:YES];
    }
    
}

-(NSString *)calPrice
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [f setUsesGroupingSeparator:NO];
    NSNumber *temp = [f numberFromString:self.saleAllPrice.text];
    NSLog(@"[f stringFromNumber:temp] ,%@",[f stringFromNumber:temp]);
    NSNumber *count = [f numberFromString:self.salesCount.text];
    temp = [NSNumber numberWithFloat:[temp floatValue] / [count intValue]];
    
    NSLog(@"[f stringFromNumber:temp] ,%@",[f stringFromNumber:temp]);
    return [f stringFromNumber:temp];
}


#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return self.userLogin.modelNameStoreList;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index{
    // invoked when an available suggestion is selected
    NSLog(@"%@ - Suggestion chosen: %d", completer, index);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.salesCount)
    {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setUsesGroupingSeparator:NO];
        NSNumber *temp = [f numberFromString:self.salesPrice.text];
        NSNumber *count = [f numberFromString:self.salesCount.text];
        temp = [NSNumber numberWithFloat:[temp floatValue] * [count intValue]];
        
        self.saleAllPrice.text = [f stringFromNumber:temp];
    }
    if (textField == self.saleAllPrice)
    {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setUsesGroupingSeparator:NO];
        NSNumber *temp = [f numberFromString:self.saleAllPrice.text];
        NSNumber *count = [f numberFromString:self.salesCount.text];
        temp = [NSNumber numberWithFloat:[temp floatValue] / [count intValue]];
        
        self.salesPrice.text = [NSString stringWithFormat:@"%.2f", [temp floatValue]];
    }
    if (textField == self.salesPrice)
    {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setUsesGroupingSeparator:NO];
        NSNumber *temp = [f numberFromString:self.salesPrice.text];
        NSNumber *count = [f numberFromString:self.salesCount.text];
        temp = [NSNumber numberWithFloat:[temp floatValue] * [count intValue]];
        
        self.saleAllPrice.text = [NSString stringWithFormat:@"%.2f", [temp floatValue]];
    }
}

-(void)firstHandle:(UIGestureRecognizer *)gestureRecognizer
{
    [dropDownTableView removeFromSuperview];
    [self.view endEditing:TRUE];
}

#pragma mark -
#pragma mark UITextField
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.saleAllPrice || textField == self.salesPrice) {
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        NSCharacterSet *numbers;
        NSRange         pointRange = [textField.text rangeOfString:@"."];
        
        if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789"];
        }
        else
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789."];
        }
        
        if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )
        {
            return NO;
        }
        
        short remain = 2; //默认保留2位小数
        
        NSString *tempStr = [textField.text stringByAppendingString:string];
        NSUInteger strlen = [tempStr length];
        if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
            if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                return NO;
            }
            if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return NO;
            }
        }
        
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string;
                return NO;
            }else{
                if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if([string isEqualToString:@"0"]){
                        return NO;
                    }
                }
            }
        }
        
        if([textField.text length] == 1){
            if([string isEqualToString:@"-"]){ //当输入框内已经含有“-”时，如果再输入“-”则被视为无效。
                return YES;
            }
        }
        else{
            if([textField.text length] > 1){ //判断输入框内是否含有“-”。
                //if(pointNumber.length == 1 && pointNumber.location ==0){
                if([string isEqualToString:@"-"]){ //当输入框内已经含有“-”时，如果再输入“-”则被视为无效。
                    return NO;
                }
            }
        }
        
        NSString *buffer;
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
        {
            return NO;
        }
        
    }
    
    return YES;
}

-(IBAction)dataPick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    flagTag = btn.tag;
    
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [self.dateFormatter dateFromString:@"2012-12-01"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [self.view addSubview:calendar];
    //NSLog(@"点击日期事件");
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    NSString *backStr = [[NSString alloc] initWithFormat:[self.dateFormatter stringFromDate:date]];
    if(flagTag == 0){
        [self.upDate setTitle:backStr forState:UIControlStateNormal];
    }else{
        [self.downDate setTitle:backStr forState:UIControlStateNormal];
    }
    [calendar removeFromSuperview];
}

@end
