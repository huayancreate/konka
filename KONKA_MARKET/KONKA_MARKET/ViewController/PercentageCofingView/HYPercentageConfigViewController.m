//
//  HYPercentageConfigViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-18.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYPercentageConfigViewController.h"
#import "HYPercentageCompetitionViewController.h"

@interface HYPercentageConfigViewController ()
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic) Boolean percentFlag;

@end

@implementation HYPercentageConfigViewController
@synthesize mainTableView;
@synthesize dyArray;
@synthesize uiModelLabel;
@synthesize uiPercentLabel;
@synthesize uiPercentCellLabel;
@synthesize percentString;
@synthesize uiModelTextField = _textField;
@synthesize autoCompleter = _autoCompleter;
@synthesize percentFlag;
@synthesize uibgLabel;
@synthesize uibgLabel1;


- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.uiModelTextField inViewController:self withOptions:options];
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
    percentFlag = true;
    
    NSNumber *flag = [[NSNumber alloc] initWithInt:0];
    // 自动补全
    [self getAllModelNameList:self.userLogin.user_id ByFlag:flag];
    
    [self getPercentListByUserID:self.userLogin.user_id];

    
    UIView *tempView = [[UIView alloc] init];
    [mainTableView setBackgroundView:tempView];
    
    
    [self.uiFixed setBackgroundColor:[UIColor blueColor]];
    [self.uiPercent setBackgroundColor:[UIColor clearColor]];
    
    [self.uiFixed.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiPercent.titleLabel setTextColor:[UIColor blackColor]];
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    
    [self.uiModelTextField addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.uiPercentTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.uiPercentTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.percentString = @"固定提成";
    
    self.uibgLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHandle:)];
    [self.uibgLabel addGestureRecognizer:gesture];
    
    self.uibgLabel1.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHandle:)];
    [self.uibgLabel1 addGestureRecognizer:gesture1];
    
    self.mainTableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHandle:)];
    [self.mainTableView addGestureRecognizer:gesture2];
    
}

-(void) getAllModelNameList:(NSNumber *)user_id ByFlag:(NSNumber *)flag
{    
    self.userLogin.modelNameCopyList = [self.kkM getAllModelNameListByUserID:user_id ByFlag:flag];
}

- (IBAction)textFieldFinished:(id)sender {
    
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
    
    return [self.userLogin.percentList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYpercentTabelViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [self.userLogin.percentList objectAtIndex:indexPath.row];
    self.uiModelLabel.text = nil;
    self.uiPercentCellLabel.text = nil;
    self.uiPercentLabel.text = nil;
    self.uiModelLabel.text = [dic objectForKey:@"model_name"];
    self.uiPercentCellLabel.text = [dic objectForKey:@"percent"];
    if ([[dic objectForKey:@"percent_style"] isEqualToString:@"0"])
    {
        self.uiPercentLabel.text = @"固定提成";
    }else
    {
        self.uiPercentLabel.text = @"按比例提成";
    }
    
    return cell;
}


-(IBAction)fixedAction:(id)sender
{
    percentFlag = true;
    [self.uiFixed setBackgroundColor:[UIColor blueColor]];
    [self.uiPercent setBackgroundColor:[UIColor clearColor]];
    self.percentString = @"固定提成";
    [self.uiFixed.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiPercent.titleLabel setTextColor:[UIColor blackColor]];

}

-(IBAction)percentAction:(id)sender
{
    percentFlag = false;
    [self.uiFixed setBackgroundColor:[UIColor clearColor]];
    [self.uiPercent setBackgroundColor:[UIColor blueColor]];
     self.percentString = @"按比例提成";
    [self.uiFixed.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiPercent.titleLabel setTextColor:[UIColor blackColor]];
    
}

-(Boolean)checkModelName:(NSString *)name
{
    return [self.userLogin.modelNameCopyList containsObject:name];
}

-(IBAction)saveAction:(id)sender
{
    
    if (![self checkTextisNull])
    {
        return;
    }
    
    if (![self checkModelName:self.uiModelTextField.text])
    {
        [super errorMsg:@"型号不在基础数据范围内！"];
        return;
    }
    if (!percentFlag)
    {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *temp = [f numberFromString:self.uiPercentTextField.text];
        if ([temp floatValue] > 100)
        {
            [super errorMsg:@"按比例分成不能大于100！"];
            return;
        }
    }
    
    NSString *perStyle = nil;
    
    if ([self.percentString isEqualToString:@"固定提成"])
    {
        perStyle = @"0";
    }else
    {
        perStyle = @"1";
    }
    
    if (![self checkPercentData:self.uiModelTextField.text])
    {
        
        [SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeGradient];
        [self.kkM insertPercentData:self.userLogin.user_id ModelName:self.uiModelTextField.text Percent:self.uiPercentTextField.text PercentStyle:perStyle];
        [self getPercentListByUserID:self.userLogin.user_id];
        
        [self.mainTableView reloadData];
        [SVProgressHUD dismiss];
    }else
    {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"已经存在此类型数据是否需要更新"];
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"Cancel Clicked");
                              }];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"OK Clicked");
                                  [SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeGradient];
                                  [self.kkM deletePercentData:self.userLogin.user_id ModelName:self.uiModelTextField.text];
                                [self.kkM insertPercentData:self.userLogin.user_id ModelName:self.uiModelTextField.text Percent:self.uiPercentTextField.text PercentStyle:perStyle];
                                  
                                [self getPercentListByUserID:self.userLogin.user_id];
                                  
                                [self.mainTableView reloadData];
                                [SVProgressHUD dismiss];
                              }];
        alertView.titleColor = [UIColor blueColor];
        alertView.cornerRadius = 10;
        alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        
        
        [alertView show];
    }
    
    
}

-(Boolean)checkPercentData:(NSString *)modelname
{
    return [self.kkM getPercentDataByModelName:modelname ByUserID:self.userLogin.user_id];
}

-(void)getPercentListByUserID:(NSNumber *)user_id
{
    self.userLogin.percentList = [self.kkM getAllPercentByUserID:user_id];
}

-(BOOL) checkTextisNull
{
    if( self.uiModelTextField.text.length == 0){
        //TOD 弹出警告
        NSString *msg = @"型号不能为空！";
        [super errorMsg:msg];
        return false;
    }
    if( self.uiPercentTextField.text.length == 0){
        //TOD 弹出警告
        NSString *msg = @"提成不能为空！";
        [super errorMsg:msg];
        return false;
    }
    return true;
}

#pragma mark - AutoCompleteTableViewDelegate
- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return self.userLogin.modelNameCopyList;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index{
    // invoked when an available suggestion is selected
    NSLog(@"%@ - Suggestion chosen: %d", completer, index);
}

-(void)firstHandle:(UIGestureRecognizer *)gestureRecognizer
{
    [_autoCompleter hideOptionsView];
    [self.view endEditing:TRUE];
}

@end
