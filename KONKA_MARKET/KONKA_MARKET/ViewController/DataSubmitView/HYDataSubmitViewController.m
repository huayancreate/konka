//
//  HYDataSubmitViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-18.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYDataSubmitViewController.h"
#import "HYSalesRegistrationViewController.h"
#import "KonkaManager.h"

#define NUMBERS @"0123456789\n"
#define NUMBERSPERIOD @"0123456789xX\n"


@interface HYDataSubmitViewController ()
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic, strong) UILabel *storeName;
@property (nonatomic, strong) UITextField *memo;
@property (nonatomic, strong) UITextField *saleAllPrice;
@property (nonatomic, strong) UITextField *selectChoice2;
@property (nonatomic, strong) UITextField *salesCount;
@property (nonatomic, strong) UITextField *salesPrice;
@property (nonatomic, strong) UITextField *realName;
@property (nonatomic, strong) UITextField *phoneNum;
@property (nonatomic, strong) UITextField *address;
@property (nonatomic, strong) UITextField *mastercode;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *priceLabel1;
@property (nonatomic, strong) NSString *submitMemo;
@property (nonatomic, strong) NSString *submitSaleTime;
@property (nonatomic, strong) NSString *submitSelectChoice2;
@property (nonatomic, strong) NSString *submitStoreID;
@property (nonatomic, strong) NSString *submitSalesCount;
@property (nonatomic, strong) NSString *submitSalesPrice;
@property (nonatomic, strong) NSString *submitRealname;
@property (nonatomic, strong) NSString *submitPhonenum;
@property (nonatomic, strong) NSString *submitAddress;
@property (nonatomic, strong) NSString *submitMastercode;
@property (nonatomic, strong) NSNumber *dataID;



@end

@implementation HYDataSubmitViewController
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
@synthesize submitSaleTime;
@synthesize submitSelectChoice2;
@synthesize submitStoreID;
@synthesize submitSalesCount;
@synthesize submitSalesPrice;
@synthesize submitRealname;
@synthesize submitPhonenum;
@synthesize submitAddress;
@synthesize submitMastercode;
@synthesize memo;
@synthesize salesCount;
@synthesize salesPrice;
@synthesize saleAllPrice;
@synthesize realName;
@synthesize phoneNum;
@synthesize address;
@synthesize mastercode;
@synthesize dataID;
@synthesize priceLabel;
@synthesize numLabel;
@synthesize priceLabel1;

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
    // Do any additional setup after loading the view from its nib.
    
    [self getStoreList:self.userLogin.user_id];
    
//    self.userLogin.storeList = nil;
//    
//    if (self.userLogin.storeList == nil)
//    {
//        [super errorMsg:@"没有相应的门店对应！"];
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 1] animated:YES];
//        return;
//    }
//    
//    if ([self.userLogin.storeList count] == 0)
//    {
//        [super errorMsg:@"没有相应的门店对应！"];
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
//    }
//    
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 380) style:UITableViewStyleGrouped];
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
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem  = rightButton;
    
    NSNumber *flag = [[NSNumber alloc] initWithInt:1];
    [self getAllModelNameList:self.userLogin.user_id ByFlag:flag];
    
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
    
    self.realName = [[UITextField alloc] initWithFrame:textFieldRect];
    self.phoneNum = [[UITextField alloc] initWithFrame:textFieldRect];
    self.address = [[UITextField alloc] initWithFrame:textFieldRect];
    self.mastercode = [[UITextField alloc] initWithFrame:textFieldRect];
    self.salesCount = [[UITextField alloc] initWithFrame:CGRectMake(117, 10, 145, 30)];
    self.salesPrice = [[UITextField alloc] initWithFrame:CGRectMake(117, 10, 145, 30)];
    self.saleAllPrice = [[UITextField alloc] initWithFrame:CGRectMake(117, 10, 145, 30)];
    
    self.salesPrice.delegate = self;
    self.saleAllPrice.delegate = self;
    self.salesCount.delegate = self;
    
    self.salesCount.text = @"1";
    saleAllPrice.text = @"0.0";
    salesPrice.text = @"0.0";
    
    
    [self.salesCount setKeyboardType:UIKeyboardTypeNumberPad];
    [self.saleAllPrice setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.salesPrice setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.phoneNum setKeyboardType:UIKeyboardTypeNamePhonePad];
    
    
    [self.memo addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.realName addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.phoneNum addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.phoneNum setKeyboardType:UIKeyboardTypeNumberPad];
    
    [self.address addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.mastercode addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];

    
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
        salesCount.enabled = false;
        saleAllPrice.enabled = false;
        self.selectChoice2.enabled = false;
        self.salesPrice.enabled = false;
        self.memo.enabled = false;
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setUsesGroupingSeparator:NO];
        storeName.text = [self.userLogin.dataSubmit objectForKey:@"dept_name"];
        salesCount.text = [numberFormatter stringFromNumber:[self.userLogin.dataSubmit objectForKey:@"num"]];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        saleAllPrice.text = [numberFormatter stringFromNumber:[self.userLogin.dataSubmit objectForKey:@"all_price"]];
        NSLog(@"saleAllPrice.text %@",saleAllPrice.text);
        salesPrice.text = [self calPrice];
        self.selectChoice2.text = [self.userLogin.dataSubmit objectForKey:@"model_name"];
        self.dataID = [self.userLogin.dataSubmit objectForKey:@"id"];
        
        memo.text = [self.userLogin.dataSubmit objectForKey:@"memo"];
        
        mastercode.text = [self.userLogin.dataSubmit objectForKey:@"mastercode"];
        
        realName.text = [self.userLogin.dataSubmit objectForKey:@"realname"];
        
        phoneNum.text = [self.userLogin.dataSubmit objectForKey:@"phonenum"];
        
        address.text = [self.userLogin.dataSubmit objectForKey:@"addresss"];
        
        NSLog(@"dataID , %d", [self.dataID intValue]);
    }
    
    if (self.userLogin.allDataSubmit != nil)
    {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setUsesGroupingSeparator:NO];
        storeName.text = [self.userLogin.allDataSubmit objectForKey:@"dept_name"];
        salesCount.text = [numberFormatter stringFromNumber:[self.userLogin.allDataSubmit objectForKey:@"num"]];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        saleAllPrice.text = [numberFormatter stringFromNumber:[self.userLogin.allDataSubmit objectForKey:@"all_price"]];
        NSLog(@"saleAllPrice.text %@",saleAllPrice.text);
        salesPrice.text = [self calPrice];
        self.selectChoice2.text = [self.userLogin.allDataSubmit objectForKey:@"model_name"];
        self.dataID = [self.userLogin.allDataSubmit objectForKey:@"id"];
        
        memo.text = [self.userLogin.allDataSubmit objectForKey:@"memo"];
        
        mastercode.text = [self.userLogin.allDataSubmit objectForKey:@"mastercode"];
        
        realName.text = [self.userLogin.allDataSubmit objectForKey:@"realname"];
        
        phoneNum.text = [self.userLogin.allDataSubmit objectForKey:@"phonenum"];
        
        address.text = [self.userLogin.allDataSubmit objectForKey:@"addresss"];
        
        storeName.enabled = false;
        salesCount.enabled = false;
        saleAllPrice.enabled = false;
        self.selectChoice2.enabled = false;
        self.salesPrice.enabled = false;
        self.memo.enabled = false;
        self.mastercode.enabled = false;
        self.realName.enabled = false;
        self.phoneNum.enabled = false;
        self.address.enabled = false;
        NSLog(@"dataID , %d", [self.dataID intValue]);
    }
    
   
}

-(void) getAllModelNameList:(NSNumber *)user_id ByFlag:(NSNumber *)flag
{
    self.userLogin.modelNameStoreList = [self.kkM getAllModelNameListByUserID:user_id ByFlag:flag];
    NSLog(@"getAllModelNameList %d" , [self.userLogin.modelNameStoreList count]);
}

- (void) getStoreList:(NSNumber *)user_id
{
    NSLog(@"getStoreList user_id %d", [user_id intValue]);
    NSNumber *flag = [[NSNumber alloc] initWithInt:0];
    
    self.userLogin.storeList = [self.kkM getStoreListByUserID:user_id ByType:@"storeList" ByFlag:flag];
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
    
    if (self.realName.text == nil)
    {
        submitRealname = @"";
    }else
    {
        submitRealname = self.realName.text;
    }
    
    if (self.phoneNum.text == nil)
    {
        submitPhonenum = @"";
    }else
    {
        submitPhonenum = self.phoneNum.text;
    }
    
    if (self.address.text == nil)
    {
        submitAddress = @"";
    }else
    {
        submitAddress = self.address.text;
    }
    
    if (self.mastercode.text == nil)
    {
        submitMastercode = @"";
    }else
    {
        submitMastercode = self.mastercode.text;
    }
    
    NSDictionary *params = nil;
    
    if (self.dataID == nil)
    {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name,@"username",self.userLogin.password,@"userpass",@"DoSubmit01",@"method",[super getNowDateYYYYMMDD],@"sale_date",submitStoreID,@"store_id",submitMemo,@"memo",submitSalesCount,@"sales_count",submitSalesPrice,@"sales_price",submitRealname,@"realname",submitPhonenum,@"phonenum",submitAddress,@"addresss",submitMastercode,@"mastercode",submitSelectChoice2,@"select-choice-2",@"2",@"data_source",nil];
    }else
    {
        if ([self.realName.text isEqualToString:@""])
        {
            [super errorMsg:@"顾客姓名不能为空！"];
            return;
        }
        if ([self.phoneNum.text isEqualToString:@""])
        {
            [super errorMsg:@"顾客电话不能为空！"];
            return;
        }
        if (self.realName.text == nil)
        {
            submitRealname = @"";
        }else
        {
            submitRealname = self.realName.text;
        }
        
        if (self.phoneNum.text == nil)
        {
            submitPhonenum = @"";
        }else
        {
            submitPhonenum = self.phoneNum.text;
        }
        params = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name,@"username",self.userLogin.password,@"userpass",@"DoSubmit01",@"method",[super getNowDateYYYYMMDD],@"sale_date",submitStoreID,@"store_id",submitMemo,@"memo",submitSalesCount,@"sales_count",submitSalesPrice,@"sales_price",submitRealname,@"realname",submitPhonenum,@"phonenum",submitAddress,@"addresss",submitMastercode,@"mastercode",submitSelectChoice2,@"select-choice-2",@"2",@"data_source",self.dataID,@"id",nil];
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
        realName.text = nil;
        address.text = nil;
        phoneNum.text = nil;
        mastercode.text = nil;
        if (self.userLogin.dataSubmit != nil)
        {
            HYSalesRegistrationViewController *c = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2];
            NSString *currentDate = c.dateLabel.text;
            [c getHisDataByStartTime:[super getFirstDayFromMoth:currentDate] endTime:[super getLastDayFromMoth:currentDate]];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
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
    if (tableView == mainTableView) {
        return 2;
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == mainTableView) {
        switch (section) {
            case 0:
                return 7;
                break;
            case 1:
                return 4;
                break;
        }
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
                        [cell.contentView addSubview:self.salesCount];
                        cell.accessoryView = self.numLabel;
                        self.cellLabel4.text = @"数量";
                        return cell;
                        break;
                    case 4:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        [cell.contentView addSubview:self.salesPrice];
                        cell.accessoryView = self.priceLabel1;
                        self.cellLabel4.text = @"单价";
                        return cell;
                        break;
                    case 5:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        [cell.contentView addSubview:self.saleAllPrice];
                        cell.accessoryView = self.priceLabel;
                        self.cellLabel4.text = @"金额";
                        return cell;
                        break;
                    case 6:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        cell.accessoryView = self.memo;
                        self.cellLabel4.text = @"备注";
                        return cell;
                        break;
                }
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        cell.accessoryView = self.realName;
                        self.cellLabel4.text = @"顾客姓名";
                        return cell;
                        break;
                    case 1:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        cell.accessoryView = self.phoneNum;
                        self.cellLabel4.text = @"顾客电话";
                        return cell;
                        break;
                    case 2:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        cell.accessoryView = self.address;
                        self.cellLabel4.text = @"顾客地址";
                        return cell;
                        break;
                    case 3:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                        cell.accessoryView = self.mastercode;
                        self.cellLabel4.text = @"顾客身份证";
                        return cell;
                        break;
                }
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
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
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
        HYSalesRegistrationViewController *srView = [[HYSalesRegistrationViewController alloc] init];
        srView.userLogin = self.userLogin;
        srView.title = @"销售登记";
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
    if (textField == self.salesCount || textField == self.phoneNum)
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered =
        [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    
    if (textField == self.mastercode)
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSPERIOD] invertedSet];
        NSString *filtered =
        [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    
    if (textField == self.saleAllPrice || textField == self.salesPrice) {
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        NSCharacterSet *numbers;
        NSRange         pointRange = [textField.text rangeOfString:@"."];
        
        if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }
        else
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
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
        
        NSString *buffer;
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
        {
            return NO;
        }
        
    }
    
    return YES;
}

@end
