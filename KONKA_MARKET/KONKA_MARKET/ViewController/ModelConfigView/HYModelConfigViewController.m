//
//  HYModelConfigViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-17.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYModelConfigViewController.h"
#import "KonkaManager.h"

@interface HYModelConfigViewController ()
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic, strong) NSNumber *flag;
@property (nonatomic, strong) NSMutableArray *percentageList;
@property (nonatomic, strong) UIImage *unsetImg;
@property (nonatomic, strong) UIImage *setImg;
@property (nonatomic) int page;

@end

@implementation HYModelConfigViewController
@synthesize modelConfigTableView;
@synthesize tableViewCell;
@synthesize searchTextField = _textField;
@synthesize autoCompleter = _autoCompleter;
@synthesize uiLableModelName;
@synthesize uiSearchBtn;
@synthesize uiSetModelBtn;
@synthesize uiCancelModelLabel;

- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.searchTextField inViewController:self withOptions:options];
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

-(void) getAllModelNameListByUserID:(NSNumber *)user_id
{
    [self.userLogin.modelNameCopyList removeAllObjects];
    if ([self.flag intValue] == 0)
    {
        self.userLogin.modelNameCopyList = [self.kkM getAllUnusualModelNameListByUserID:user_id];
    
    }else
    {
        self.userLogin.modelNameCopyList = [self.kkM getAllUsualModelNameListByUserID:user_id];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.kkM = [[KonkaManager alloc] init];
    
    self.page = 0;
    
    self.flag = [[NSNumber alloc] initWithInt:0];
    
    // 自动补全
    [self getAllModelNameListByUserID:self.userLogin.user_id];
    
    // 分页
    [self getUnusualModelListLimitByID:self.userLogin.user_id ByName:nil ByPage:self.page];
    
    modelConfigTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, 320, [super screenHeight] - 180) style:UITableViewStyleGrouped];
    
    modelConfigTableView.delegate = self;
    modelConfigTableView.dataSource = self;
    
    modelConfigTableView.scrollEnabled = YES;
    
    UIView *tempView = [[UIView alloc] init];
    [modelConfigTableView setBackgroundView:tempView];
    
    [self.view addSubview:modelConfigTableView];
    
    [self.searchTextField addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.searchTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.setImg=[UIImage imageNamed:@"model_set.png"];
    self.unsetImg=[UIImage imageNamed:@"model_unset.png"];
    
    [self.uiModelSet setBackgroundImage:self.setImg forState:UIControlStateNormal];
    [self.uiUnModelSet setBackgroundImage:self.unsetImg forState:UIControlStateNormal];
    
//    [self.uiModelSet setBackgroundColor:[UIColor blueColor]];
//    [self.uiModelSet.titleLabel setTextColor:[UIColor blackColor]];
//    [self.uiUnModelSet.titleLabel setTextColor:[UIColor blackColor]];
    
}

-(void) getUnusualModelListLimitByID:(NSNumber *)user_id ByName:(NSString *)name ByPage:(int)page
{
    self.userLogin.modelList = [self.kkM getUnusualModelListByUserID:user_id ByName:name ByPage:page];
}

-(void) getUsualModelListLimitByID:(NSNumber *)user_id ByName:(NSString *)name ByPage:(int)page
{
    self.userLogin.modelList = [self.kkM getUsualModelListByUserID:user_id ByName:name ByPage:page];
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldDidEndEditing:(id)sender
{
    
}

-(IBAction)modelSetAction:(id)sender
{
    self.page = 0;
    self.flag = [[NSNumber alloc] initWithInt:0];
    
    NSString *name = nil;
    if (self.searchTextField.text.length != 0)
    {
        name = self.searchTextField.text;
    }
    
    [self getUnusualModelListLimitByID:self.userLogin.user_id ByName:name ByPage:self.page];
    
    [self.uiModelSet setBackgroundImage:self.setImg forState:UIControlStateNormal];
    [self.uiUnModelSet setBackgroundImage:self.unsetImg forState:UIControlStateNormal];
    [self getAllModelNameListByUserID:self.userLogin.user_id];
    
//    [self.uiModelSet setBackgroundColor:[UIColor blueColor]];
//    
//    [self.uiUnModelSet setBackgroundColor:[UIColor clearColor]];
//    
//    [self.uiModelSet.titleLabel setTextColor:[UIColor blackColor]];
//    [self.uiUnModelSet.titleLabel setTextColor:[UIColor blackColor]];
    
    [self.modelConfigTableView reloadData];
}

-(IBAction)unmModelSetAction:(id)sender
{
    
    self.page = 0;
    self.flag = [[NSNumber alloc] initWithInt:1];
    
    NSString *name = nil;
    if (self.searchTextField.text.length != 0)
    {
        name = self.searchTextField.text;
    }
    
    [self getUsualModelListLimitByID:self.userLogin.user_id ByName:name ByPage:self.page];
    
    [self.uiModelSet setBackgroundImage:self.unsetImg forState:UIControlStateNormal];
    [self.uiUnModelSet setBackgroundImage:self.setImg forState:UIControlStateNormal];
    [self getAllModelNameListByUserID:self.userLogin.user_id];
    
//    [self.uiModelSet setBackgroundColor:[UIColor clearColor]];
//    
//    [self.uiUnModelSet setBackgroundColor:[UIColor blueColor]];
//    
//    [self.uiModelSet.titleLabel setTextColor:[UIColor blackColor]];
//    [self.uiUnModelSet.titleLabel setTextColor:[UIColor blackColor]];
    
    [self.modelConfigTableView reloadData];

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
    return [self.userLogin.modelList count];
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ModelConfigTabelViewCell" owner:self options:nil];
    NSNumber *one = [[NSNumber alloc] initWithInt:1];
    NSNumber *zero = [[NSNumber alloc] initWithInt:0];
    cell = [nib objectAtIndex:[self.flag intValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.flag isEqualToNumber:one]) {
        uiCancelModelLabel.text = [self.userLogin.modelList objectAtIndex:indexPath.row];
    }
    if ([self.flag isEqualToNumber:zero]) {
        uiLableModelName.text = [self.userLogin.modelList objectAtIndex:indexPath.row];
    }
    
    uiSetModelBtn.tag = indexPath.row;

    return  cell;
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

-(IBAction)setDefaultModel:(id)sender
{
    self.page = 0;
    UIButton *btnTag = (UIButton *)sender;
    NSString *name = [self.userLogin.modelList objectAtIndex:btnTag.tag];
    NSLog(@"name setDefaultModel %@" , name);
    
    NSString *str = nil;
    
    if (self.searchTextField.text.length != 0)
    {
        str = self.searchTextField.text;
    }
    
    [SVProgressHUD showWithStatus:@"正在更新..." maskType:SVProgressHUDMaskTypeGradient];
   
    [self.kkM insertSetUsual:name ByUserID:self.userLogin.user_id];
    
    [self getUnusualModelListLimitByID:self.userLogin.user_id ByName:str ByPage:self.page];
    
    [self.modelConfigTableView reloadData];
    [SVProgressHUD dismiss];

}

-(IBAction)unSetDefaultModel:(id)sender
{
    self.page = 0;
    UIButton *btnTag = (UIButton *)sender;
    NSString *name = [self.userLogin.modelList objectAtIndex:btnTag.tag];
    NSLog(@"name unSetDefaultModel %@",name);
    NSString *str = nil;
    
    if (self.searchTextField.text.length != 0)
    {
        str = self.searchTextField.text;
    }
    
    
    [SVProgressHUD showWithStatus:@"正在更新..." maskType:SVProgressHUDMaskTypeGradient];
    
    [self.kkM deleteSetUsualByUserID:self.userLogin.user_id AndName:name];
    
    [self getUsualModelListLimitByID:self.userLogin.user_id ByName:str ByPage:self.page];
    
    [self.modelConfigTableView reloadData];
    [SVProgressHUD dismiss];
}

-(IBAction)search:(id)sender
{
    NSLog(@"self.searchTextField.text %@",self.searchTextField.text);
    self.page = 0;
    
    NSString *str = nil;
    if (self.searchTextField.text.length != 0){
        str = self.searchTextField.text;
        str = [str uppercaseString];
    }
    
    if ([self.flag intValue] == 0)
    {
        [self getUnusualModelListLimitByID:self.userLogin.user_id ByName:str ByPage:self.page];
    }else
    {
        [self getUsualModelListLimitByID:self.userLogin.user_id ByName:str ByPage:self.page];
    }
    [_autoCompleter hideOptionsView];
    [self.modelConfigTableView reloadData];
}

-(IBAction)up:(id)sender
{
    NSString *str = nil;
    if (self.searchTextField.text.length != 0)
    {
        str = self.searchTextField.text;
    }
    if (self.page == 0)
    {
        self.page = 0;
    }else
    {
        self.page = self.page - 1;
    }
    if ([self.flag intValue] == 0)
    {
        [self getUnusualModelListLimitByID:self.userLogin.user_id ByName:str ByPage:self.page];
    }else
    {
        [self getUsualModelListLimitByID:self.userLogin.user_id ByName:str ByPage:self.page];    
    }
    [self.modelConfigTableView reloadData];
}

-(IBAction)down:(id)sender
{
    NSString *str = nil;
    if (self.searchTextField.text.length != 0)
    {
        str = self.searchTextField.text;
    }
    
    if([self.userLogin.modelList count] < 20)
    {
        self.page = self.page;
    }else
    {
        self.page = self.page + 1;
    }
    if ([self.flag intValue] == 0)
    {
        [self getUnusualModelListLimitByID:self.userLogin.user_id ByName:str ByPage:self.page];
    }else
    {
        [self getUsualModelListLimitByID:self.userLogin.user_id ByName:str ByPage:self.page];
    }
    [self.modelConfigTableView reloadData];
}

@end
