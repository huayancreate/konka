//
//  HYCompetitionSalesViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-17.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYCompetitionSalesViewController.h"
#import "HYCompetitionSalesHisViewController.h"

#define NUMBERS @"0123456789\n"

@interface HYCompetitionSalesViewController ()
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic, strong) UITextField *theTextField;
@property (nonatomic, strong) UILabel *storeName;
@property (nonatomic, strong) UILabel *brandName;
@property (nonatomic, strong) UITextField *selectChoice2;
@property (nonatomic, strong) UITextField *saleAllPrice;
@property (nonatomic, strong) UITextField *salesCount;
@property (nonatomic, strong) UITextField *memo;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) NSString *submitSaleTime;
@property (nonatomic, strong) NSString *submitSelectChoice2;
@property (nonatomic, strong) NSString *submitStoreID;
@property (nonatomic, strong) NSString *submitSalesCount;
@property (nonatomic, strong) NSString *submitSalesPrice;
@property (nonatomic, strong) NSString *submitMemo;

@end

@implementation HYCompetitionSalesViewController
@synthesize cellLabel;
@synthesize cellTextField;
@synthesize mainTableView;
@synthesize LabelTextTableViewCell;
@synthesize cellImage;
@synthesize cellLabel1;
@synthesize cellLabel2;
@synthesize cellLabel3;
@synthesize cellLabel4;
@synthesize selectChoice2 = _textField;
@synthesize autoCompleter = _autoCompleter;
@synthesize dropDownTableView;
@synthesize brandSelectTableView;
@synthesize storeName;
@synthesize brandName;
@synthesize salesCount;
@synthesize memo;
@synthesize saleAllPrice;
@synthesize currentTextField;
@synthesize submitSaleTime;
@synthesize submitSelectChoice2;
@synthesize submitStoreID;
@synthesize submitSalesCount;
@synthesize submitSalesPrice;
@synthesize submitMemo;
@synthesize numLabel;
@synthesize priceLabel;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getStoreList:self.userLogin.user_id];
    
    [self getBrandList:self.userLogin.user_id];
     
    [self getBrandNameList:self.userLogin.user_id ByName:[self.userLogin.brandList objectAtIndex:0]];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"right.png"];
    CGRect frameimg = CGRectMake(0, 0, 32, 24);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    
    [someButton addTarget:self action:@selector(submit:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem  = rightButton;
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    UIView *tempView = [[UIView alloc] init];
    [self.mainTableView setBackgroundView:tempView];
    
    [self getStoreList:self.userLogin.user_id];
    
    CGRect textFieldRect = CGRectMake(120, 145, 175, 30);
    self.selectChoice2 = [[UITextField alloc] initWithFrame:textFieldRect];
    self.salesCount = [[UITextField alloc] initWithFrame:CGRectMake(117, 10, 145, 30)];
    self.memo = [[UITextField alloc] initWithFrame:textFieldRect];
    self.saleAllPrice = [[UITextField alloc] initWithFrame:CGRectMake(117, 10, 145, 30)];
    
    self.salesCount.text = @"1";
    self.saleAllPrice.text = @"0.0";
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.priceLabel setBackgroundColor:[UIColor clearColor]];
    self.priceLabel.text = @"元";
    
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.numLabel setBackgroundColor:[UIColor clearColor]];
    self.numLabel.text = @"台";
    
    [self.salesCount setKeyboardType:UIKeyboardTypeNumberPad];
    [self.saleAllPrice setKeyboardType:UIKeyboardTypeDecimalPad];
    
    self.saleAllPrice.clearsOnBeginEditing = YES;
    
    [self.salesCount addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.salesCount addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.memo addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.memo addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.saleAllPrice addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.saleAllPrice addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.selectChoice2 addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.selectChoice2 addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.uibglabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHandle:)];
    [self.uibglabel addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHandle:)];
    [self.mainTableView addGestureRecognizer:singleTap1];
    
    CGRect labelFieldRect = CGRectMake(0, 0, 175, 30);
    
    storeName = [[UILabel alloc] initWithFrame:labelFieldRect];
    
    self.saleAllPrice.delegate = self;
    self.memo.delegate = self;
    self.salesCount.delegate = self;
    
    NSDictionary *dic = [self.userLogin.storeList objectAtIndex:0];
    storeName.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeSelectAction:)];
    [storeName addGestureRecognizer:singleTap];
    storeName.text = [dic objectForKey:@"name"];
    NSLog(@"storeName.text ,%@", storeName.text);
    [storeName setBackgroundColor:[UIColor clearColor]];
    
    brandName = [[UILabel alloc] initWithFrame:labelFieldRect];
    
    brandName.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(brandSelectAction:)];
    [brandName addGestureRecognizer:singleTap2];
    brandName.text = [self.userLogin.brandList objectAtIndex:0];
    [brandName setBackgroundColor:[UIColor clearColor]];
    
    self.selectChoice2.text = brandName.text;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}



-(void) getBrandNameList:(NSNumber *)user_id ByName:(NSString *)_brandName
{
    self.userLogin.brandNameList = [self.kkM getBrandNameListByUserID:user_id ByName:_brandName];
}

- (void) getStoreList:(NSNumber *)user_id
{
    
    self.userLogin.storeList = [self.kkM getStoreListByUserID:user_id];
    
    NSLog(@"asdasd ,%d", [self.userLogin.storeList count]);
}

- (void) getBrandList:(NSNumber *)user_id
{
    self.userLogin.brandList = [self.kkM getBrandListByUserID:user_id];
}

-(void)submit:(id)sender{
    
    [SVProgressHUD showWithStatus:@"数据提交中..." maskType:SVProgressHUDMaskTypeGradient];
    submitSelectChoice2 = [self.kkM findBrandID:self.userLogin.user_id ByName:self.selectChoice2.text];
    
    submitStoreID = [self.kkM findStoreID:self.userLogin.user_id ByName:self.storeName.text];
    
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
    
    if (self.memo.text == nil)
    {
        submitMemo = @"";
    }else
    {
        submitMemo = self.memo.text;
    }
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name,@"username",self.userLogin.password,@"userpass",@"DoSubmit06",@"method",[super getNowDateYYYYMMDD],@"sale_date",submitStoreID,@"store_id",submitSalesCount,@"sales_count",submitSalesPrice,@"sales_price",submitSelectChoice2,@"model",@"2",@"data_source",submitMemo,@"memo",nil];
    
    NSLog(@"submit params %@", [HYAppUtily stringOutputForDictionary:params]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:DataSubmitApi]];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];

}

-(void) endFailedRequest:(NSString *)msg
{
    [super errorMsg:@"网络出现问题！"];
}

-(void) endRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    
    if ([msg isEqualToString:@"success"])
    {
       [super successMsg:@"提交成功"];
        self.selectChoice2.text = brandName.text;
        salesCount.text = @"1";
        saleAllPrice.text = @"0.0";
        memo.text = @"";
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(tableView == dropDownTableView)
    {
        return [self.userLogin.storeList count];
    }
    if(tableView == brandSelectTableView)
    {
        return [self.userLogin.brandList count];
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == dropDownTableView || tableView == brandSelectTableView)
    {
        return 0;
    }
    return 10;
}

-(HYTableViewCell *) createTabelViewCellForIndentifier: (NSString *) indentifier NibNamed: (NSString *) nibName tableView:(UITableView *)tableView index:(int) index{
    
    HYTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier: indentifier];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];
    cell = [nib objectAtIndex:index];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)brandSelectAction:(UIGestureRecognizer *)gestureRecognizer
{
    if (brandSelectTableView != nil)
    {
        [brandSelectTableView removeFromSuperview];
        brandSelectTableView = nil;
    }
    brandSelectTableView = [[UITableView alloc] initWithFrame:CGRectMake(107, 123, 175, 132) style:UITableViewStylePlain];
    brandSelectTableView.scrollEnabled = YES;
    
    brandSelectTableView.delegate = self;
    brandSelectTableView.dataSource = self;
    
    [self.view addSubview:brandSelectTableView];
    
    UIView *tempView = [[UIView alloc] init];
    [brandSelectTableView setBackgroundView:tempView];
}

-(void)storeSelectAction:(UIGestureRecognizer *)gestureRecognizer
{
    if (dropDownTableView != nil)
    {
        [dropDownTableView removeFromSuperview];
        dropDownTableView = nil;
    }
    dropDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(110, 85, 175, 132) style:UITableViewStylePlain];
    dropDownTableView.scrollEnabled = YES;
    
    dropDownTableView.delegate = self;
    dropDownTableView.dataSource = self;
    
    [self.view addSubview:dropDownTableView];
    
    UIView *tempView = [[UIView alloc] init];
    [dropDownTableView setBackgroundView:tempView];
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
    
    if (tableView == brandSelectTableView)
    {
        brandName.text = [self.userLogin.brandList objectAtIndex:indexPath.row];
        [brandSelectTableView removeFromSuperview];
        
        self.selectChoice2.text = brandName.text;
        
        [self getBrandNameList:self.userLogin.user_id ByName:brandName.text];
        
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSDictionary *dic = nil;
    if (tableView == brandSelectTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier: @"LabelTextCellIdentifier"];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        self.cellLabel.text = [self.userLogin.brandList objectAtIndex:indexPath.row];
        UIView *temp = [[UIView alloc] init];
        [cell setBackgroundView:temp];
        return cell;
    }
    
    
    if (tableView == dropDownTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier: @"LabelTextCellIdentifier"];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        dic = (NSDictionary *)[self.userLogin.storeList objectAtIndex:indexPath.row];
        self.cellLabel.text = [dic objectForKey:@"name"];
        UIView *temp = [[UIView alloc] init];
        [cell setBackgroundView:temp];
        return cell;
    }
    
    if (tableView == mainTableView)
    {
        switch (indexPath.row) {
            case 0:
                cell = [self createTabelViewCellForIndentifier:@"DropDownCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                cell.accessoryView = storeName;
                self.cellLabel4.text = @"门店";
                return cell;
                break;
            case 1:
                cell = [self createTabelViewCellForIndentifier:@"DropDownCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                cell.accessoryView = brandName;
                self.cellLabel4.text = @"品牌";
                return cell;
                break;
            case 2:
                cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                cell.accessoryView = self.selectChoice2;
                self.cellLabel4.text = @"型号";
                return cell;
                break;
            case 3:
                cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                cell.accessoryView = self.numLabel;
                [cell.contentView addSubview:self.salesCount];
                self.cellLabel4.text = @"数量";
                return cell;
                break;
            case 4:
                cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                [cell.contentView addSubview:self.saleAllPrice];
                cell.accessoryView = self.priceLabel;
                self.cellLabel4.text = @"金额";
                return cell;
                break;
            case 5:
                cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                cell.accessoryView = self.memo;
                self.cellLabel4.text = @"备注";
                return cell;
                break;

        }
    }

    return  cell;
}

    // Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
        // [sender resignFirstResponder];
}

- (IBAction)hisAction:(id)sender{
    [dropDownTableView removeFromSuperview];
    [brandSelectTableView removeFromSuperview];
    
    HYCompetitionSalesHisViewController *hys = [[HYCompetitionSalesHisViewController alloc] init];
    hys.userLogin = self.userLogin;
    hys.title = @"竞品历史";
    [self.navigationController pushViewController:hys animated:YES];
}

#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return self.userLogin.brandNameList;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index{
    // invoked when an available suggestion is selected
    NSLog(@"%@ - Suggestion chosen: %d", completer, index);
}

-(void)firstHandle:(UIGestureRecognizer *)gestureRecognizer
{
    [dropDownTableView removeFromSuperview];
    [brandSelectTableView removeFromSuperview];
    [self.view endEditing:TRUE];
}

#pragma mark -
#pragma mark UITextField
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.salesCount)
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered =
        [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    if (textField == self.saleAllPrice) {
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
