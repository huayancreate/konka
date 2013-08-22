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
@property (nonatomic, strong) UIImage *unsetImg;
@property (nonatomic, strong) UIImage *setImg;
@property (nonatomic, strong) UITextField *uiTextPercent;

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
@synthesize uiTextPercent;



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
    
    
    uiTextPercent = [[UITextField alloc] initWithFrame:CGRectMake(98, 107, 109, 30)];
    uiTextPercent.borderStyle = UITextBorderStyleLine;
    uiTextPercent.delegate = self;
    
    [self.view addSubview:uiTextPercent];
    
    // 自动补全
    [self getAllModelNameList:self.userLogin.user_id];
    
    [self getPercentListByUserID:self.userLogin.user_id];

    
    UIView *tempView = [[UIView alloc] init];
    [mainTableView setBackgroundView:tempView];
    
    [self.uiFixed setBackgroundColor:[UIColor blueColor]];
    [self.uiPercent setBackgroundColor:[UIColor clearColor]];
    
    [self.uiFixed.titleLabel setTextColor:[UIColor blackColor]];
    
    [self.uiPercent.titleLabel setTextColor:[UIColor blackColor]];
    
    
    self.setImg=[UIImage imageNamed:@"model_set.png"];
    self.unsetImg=[UIImage imageNamed:@"model_unset.png"];
    
    [self.uiFixed setBackgroundImage:self.setImg forState:UIControlStateNormal];
    [self.uiPercent setBackgroundImage:self.unsetImg forState:UIControlStateNormal];
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    [self.uiModelTextField addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
//    [self.uiPercentTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    //self.uiPercentTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    
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

-(void) getAllModelNameList:(NSNumber *)user_id
{    
    self.userLogin.modelNameCopyList = [self.kkM getAllModelNameListByUserID:user_id];
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
    if ([[dic objectForKey:@"percent_style"] isEqualToString:@"0"])
    {
        self.uiPercentLabel.text = @"固定提成";
        self.uiPercentCellLabel.text = [[dic objectForKey:@"percent"] stringByAppendingString:@"元"];
    }else
    {
        self.uiPercentLabel.text = @"按比例提成";
        self.uiPercentCellLabel.text = [[dic objectForKey:@"percent"] stringByAppendingString:@"%"];
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
    
    [self.uiFixed setBackgroundImage:self.setImg forState:UIControlStateNormal];
    [self.uiPercent setBackgroundImage:self.unsetImg forState:UIControlStateNormal];

}

-(IBAction)percentAction:(id)sender
{
    percentFlag = false;
    [self.uiFixed setBackgroundColor:[UIColor clearColor]];
    [self.uiPercent setBackgroundColor:[UIColor blueColor]];
     self.percentString = @"按比例提成";
    [self.uiFixed.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiPercent.titleLabel setTextColor:[UIColor blackColor]];
    
    [self.uiFixed setBackgroundImage:self.unsetImg forState:UIControlStateNormal];
    [self.uiPercent setBackgroundImage:self.setImg forState:UIControlStateNormal];
    
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
        NSNumber *temp = [f numberFromString:self.uiTextPercent.text];
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
        [self.kkM insertPercentData:self.userLogin.user_id ModelName:self.uiModelTextField.text Percent:self.uiTextPercent.text PercentStyle:perStyle];
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
                                [self.kkM insertPercentData:self.userLogin.user_id ModelName:self.uiModelTextField.text Percent:self.uiTextPercent.text PercentStyle:perStyle];
                                  
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
    if( self.uiTextPercent.text.length == 0){
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

#pragma mark -
#pragma mark UITextField
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.uiTextPercent) {
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
