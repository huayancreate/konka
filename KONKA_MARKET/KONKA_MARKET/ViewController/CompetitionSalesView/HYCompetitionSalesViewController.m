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
@synthesize theTextField = _textField;
@synthesize autoCompleter = _autoCompleter;

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
    
    UIImage *backButtonImage = [UIImage imageNamed:@"conform.png"];
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
    self.theTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    
    [self.theTextField addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.theTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void) getStoreList:(NSNumber *)user_id
{
    NSLog(@"getStoreList user_id %d", [user_id intValue]);
    KonkaManager *kkM = [[KonkaManager alloc] init];
    
    NSNumber *flag = [[NSNumber alloc] initWithInt:0];
    
    self.userLogin.storeList = [kkM getStoreListByUserID:user_id ByType:@"storeList" ByFlag:flag];
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



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSDictionary *dic = (NSDictionary *)[self.userLogin.storeList objectAtIndex:0];
    switch (indexPath.row) {
        case 0:
            cell = [self createTabelViewCellForIndentifier:@"DropDownCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:2];
            self.cellLabel3.text = [dic objectForKey:@"name"];
            self.cellLabel2.text = @"门店";
            return cell;
            break;
        case 1:
            cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
            
            [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
            self.cellLabel.text = @"品牌";
            return cell;
            break;
        case 2:
            cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
            
            [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
            self.cellLabel.text = @"型号";
            return cell;
            break;
        case 3:
            cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:3];
            cell.accessoryView = self.theTextField;
            self.cellLabel4.text = @"型号";
            return cell;
            break;
        case 4:
            cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
            
            [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
            self.cellLabel.text = @"金额";
            return cell;
            break;
        case 5:
            cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
            
            [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
            self.cellLabel.text = @"备注";
            return cell;
            break;
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
    return self.userLogin.modelNameStoreList;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index{
    // invoked when an available suggestion is selected
    NSLog(@"%@ - Suggestion chosen: %d", completer, index);
}

@end
