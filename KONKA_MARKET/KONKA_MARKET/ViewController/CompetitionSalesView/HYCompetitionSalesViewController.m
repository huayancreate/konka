//
//  HYCompetitionSalesViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-17.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYCompetitionSalesViewController.h"

@interface HYCompetitionSalesViewController ()
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic, strong) UITextField *theTextField;
@property (nonatomic, strong) UILabel *storeName;
@property (nonatomic, strong) UILabel *brandName;
@property (nonatomic, strong) UITextField *selectChoice2;
@property (nonatomic, strong) UITextField *memo;
@property (nonatomic, strong) UITextField *saleAllPrice;
@property (nonatomic, strong) UITextField *salesCount;
@property (nonatomic, strong) UITextField *salesPrice;
@property (nonatomic, strong) UITextField *currentTextField;

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
@synthesize memo;
@synthesize salesCount;
@synthesize salesPrice;
@synthesize saleAllPrice;
@synthesize currentTextField;

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
    
    NSNumber *flag = [[NSNumber alloc] initWithInt:0];
    [self getBrandNameList:self.userLogin.user_id ByFlag:flag ByName:[self.userLogin.brandList objectAtIndex:0]];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"right.png"];
    CGRect frameimg = CGRectMake(0, 0, 20, 24);
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
    self.memo = [[UITextField alloc] initWithFrame:textFieldRect];
    self.memo.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.salesCount = [[UITextField alloc] initWithFrame:textFieldRect];
    self.salesPrice = [[UITextField alloc] initWithFrame:textFieldRect];
    self.saleAllPrice = [[UITextField alloc] initWithFrame:textFieldRect];
    
    self.salesCount.text = @"1";
    
    [self.salesCount setKeyboardType:UIKeyboardTypeNumberPad];
    [self.saleAllPrice setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.salesPrice setKeyboardType:UIKeyboardTypeDecimalPad];
    
    
    [self.memo addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.salesCount addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.salesCount addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.salesPrice addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.salesPrice addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    
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
    
    NSDictionary *dic = [self.userLogin.storeList objectAtIndex:0];
    storeName.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeSelectAction:)];
    [storeName addGestureRecognizer:singleTap];
    storeName.text = [dic objectForKey:@"name"];
    NSLog(@"storeName.text ,%@", storeName.text);
    
    brandName = [[UILabel alloc] initWithFrame:labelFieldRect];
    
    brandName.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(brandSelectAction:)];
    [brandName addGestureRecognizer:singleTap2];
    brandName.text = [self.userLogin.brandList objectAtIndex:0];
    
    self.selectChoice2.text = brandName.text;
    
}

-(void) getBrandNameList:(NSNumber *)user_id ByFlag:(NSNumber *)flag ByName:(NSString *)_brandName
{
    KonkaManager *kkM = [[KonkaManager alloc] init];
    self.userLogin.brandNameList = [kkM getBrandNameListByUserID:user_id ByFlag:flag ByName:_brandName];
    NSLog(@"getAllModelNameList %d" , [self.userLogin.brandNameList count]);
}

- (void) getStoreList:(NSNumber *)user_id
{
    NSLog(@"getStoreList user_id %d", [user_id intValue]);
    KonkaManager *kkM = [[KonkaManager alloc] init];
    
    NSNumber *flag = [[NSNumber alloc] initWithInt:0];
    
    self.userLogin.storeList = [kkM getStoreListByUserID:user_id ByType:@"storeList" ByFlag:flag];
    
    NSLog(@"asdasd ,%d", [self.userLogin.storeList count]);
}

- (void) getBrandList:(NSNumber *)user_id
{

    NSLog(@"getBrandList user_id %d", [user_id intValue]);
    KonkaManager *kkM = [[KonkaManager alloc] init];
    
    NSNumber *flag = [[NSNumber alloc] initWithInt:0];
    
    self.userLogin.brandList = [kkM getBrandListByUserID:user_id ByFlag:flag];
    
    NSLog(@"getBrandList ,%d", [self.userLogin.brandList count]);
    NSLog(@"getBrandList ,%@", [self.userLogin.brandList objectAtIndex:0]);
}

-(void)submit:(id)sender{

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
        
        NSNumber *flag = [[NSNumber alloc] initWithInt:0];
        [self getBrandNameList:self.userLogin.user_id ByFlag:flag ByName:brandName.text];
        
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSDictionary *dic = (NSDictionary *)[self.userLogin.storeList objectAtIndex:0];
    if (tableView == brandSelectTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier: @"LabelTextCellIdentifier"];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        self.cellLabel.text = [self.userLogin.brandList objectAtIndex:indexPath.row];
        return cell;
    }
    
    
    if (tableView == dropDownTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier: @"LabelTextCellIdentifier"];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        dic = (NSDictionary *)[self.userLogin.storeList objectAtIndex:indexPath.row];
        self.cellLabel.text = [dic objectForKey:@"name"];
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
                cell.accessoryView = self.salesCount;
                self.cellLabel4.text = @"数量";
                return cell;
                break;
            case 4:
                cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                cell.accessoryView = self.salesPrice;
                self.cellLabel4.text = @"单价";
                return cell;
                break;
            case 5:
                cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
                cell.accessoryView = self.saleAllPrice;
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
    }

    return  cell;
}

    // Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
        // [sender resignFirstResponder];
}

- (IBAction)hisAction:(id)sender{
    
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.salesPrice)
    {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *temp = [f numberFromString:self.salesPrice.text];
        NSNumber *count = [f numberFromString:self.salesCount.text];
        temp = [NSNumber numberWithFloat:[temp floatValue] * [count intValue]];
        
        self.saleAllPrice.text = [f stringFromNumber:temp];
    }
    
    if (textField == self.saleAllPrice)
    {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *temp = [f numberFromString:self.saleAllPrice.text];
        NSNumber *count = [f numberFromString:self.salesCount.text];
        temp = [NSNumber numberWithFloat:[temp floatValue] / [count intValue]];
        
        self.salesPrice.text = [f stringFromNumber:temp];
    }
    
    if (textField == self.salesCount)
    {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *temp = [f numberFromString:self.salesPrice.text];
        NSNumber *count = [f numberFromString:self.salesCount.text];
        temp = [NSNumber numberWithFloat:[temp floatValue] * [count intValue]];
        
        self.saleAllPrice.text = [f stringFromNumber:temp];
    }
}
@end
