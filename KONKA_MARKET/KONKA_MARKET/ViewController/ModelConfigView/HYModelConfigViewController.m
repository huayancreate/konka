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

-(void) getAllModelNameList:(NSNumber *)user_id ByFlag:(NSNumber *)flag
{
    self.userLogin.modelNameCopyList = [self.kkM getAllModelNameListByUserID:user_id ByFlag:self.flag];
}

-(void) getModelListLimit:(NSNumber *)user_id ByFlag:(NSNumber *)flag ByName:(NSString *)name ByPage:(int) page
{
    self.userLogin.modelList = [self.kkM getModelListByUserID:user_id ByType:@"modelList" ByFlag:flag ByName:name ByPage:page];
    
    self.userLogin.modelNameList = [[NSMutableArray alloc] init];

    for (NSDictionary *dic in self.userLogin.modelList) {
        NSLog(@"[dic objectForKey:@name] %@", [dic objectForKey:@"name"]);
        [self.userLogin.modelNameList addObject:[NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]]];
        NSLog(@"self.userLogin.modelNameList %@", [self.userLogin.modelNameList objectAtIndex:0]);
    }
    NSLog(@"self.userLogin.modelNameList count %d", [self.userLogin.modelNameList count]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.kkM = [[KonkaManager alloc] init];
    
    self.flag = [[NSNumber alloc] initWithInt:0];
    
    self.page = 0;
    
    // 自动补全
    [self getAllModelNameList:self.userLogin.user_id ByFlag:self.flag];
    
    // 分页
    [self getModelListLimit:self.userLogin.user_id ByFlag:self.flag ByName:nil ByPage:self.page];
    
    modelConfigTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, 320, 260) style:UITableViewStyleGrouped];
    
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
        name = [NSString stringWithFormat:@"%@%@", @"*", self.searchTextField.text];
        name = [NSString stringWithFormat:@"%@%@", name, @"*"];
    }
    
    [self getModelListLimit:self.userLogin.user_id ByFlag:self.flag ByName:name ByPage:self.page];
    
    [self.uiModelSet setBackgroundImage:self.setImg forState:UIControlStateNormal];
    [self.uiUnModelSet setBackgroundImage:self.unsetImg forState:UIControlStateNormal];
    
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
        name = [NSString stringWithFormat:@"%@%@", @"*", self.searchTextField.text];
        name = [NSString stringWithFormat:@"%@%@", name, @"*"];
    }
    
    [self getModelListLimit:self.userLogin.user_id ByFlag:self.flag ByName:name ByPage:self.page];
    
    [self.uiModelSet setBackgroundImage:self.unsetImg forState:UIControlStateNormal];
    [self.uiUnModelSet setBackgroundImage:self.setImg forState:UIControlStateNormal];
    
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
        uiCancelModelLabel.text = [self.userLogin.modelNameList objectAtIndex:indexPath.row];
    }
    if ([self.flag isEqualToNumber:zero]) {
        uiLableModelName.text = [self.userLogin.modelNameList objectAtIndex:indexPath.row];
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
    NSString *name = [self.userLogin.modelNameList objectAtIndex:btnTag.tag];
    
    NSString *str = nil;
    
    if (self.searchTextField.text.length != 0)
    {
        str = [NSString stringWithFormat:@"%@%@", @"*", self.searchTextField.text];
        str = [NSString stringWithFormat:@"%@%@", str, @"*"];
    }
    
    [SVProgressHUD showWithStatus:@"正在更新..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSNumber *tempFlag = [[NSNumber alloc] initWithInt:1];
   
    [self.kkM updateModelListFlag:tempFlag ByName:name ByUserID:self.userLogin.user_id];
    
    [self getModelListLimit:self.userLogin.user_id ByFlag:self.flag ByName:str ByPage:self.page];
    
    [self.modelConfigTableView reloadData];
    [SVProgressHUD dismiss];

}

-(IBAction)unSetDefaultModel:(id)sender
{
    self.page = 0;
    UIButton *btnTag = (UIButton *)sender;
    NSString *name = [self.userLogin.modelNameList objectAtIndex:btnTag.tag];
    
    NSString *str = nil;
    
    if (self.searchTextField.text.length != 0)
    {
        str = [NSString stringWithFormat:@"%@%@", @"*", self.searchTextField.text];
        str = [NSString stringWithFormat:@"%@%@", str, @"*"];
    }
    
    
    [SVProgressHUD showWithStatus:@"正在更新..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSNumber *tempFlag = [[NSNumber alloc] initWithInt:0];
    
    [self.kkM updateModelListFlag:tempFlag ByName:name ByUserID:self.userLogin.user_id];
    
    [self getModelListLimit:self.userLogin.user_id ByFlag:self.flag ByName:str ByPage:self.page];
    
    [self.modelConfigTableView reloadData];
    [SVProgressHUD dismiss];
}

-(IBAction)search:(id)sender
{
    NSLog(@"self.searchTextField.text %@",self.searchTextField.text);
    
    NSString *str = nil;
    if (self.searchTextField.text.length != 0){
    
        str = [NSString stringWithFormat:@"%@%@", @"*", self.searchTextField.text];
        str = [NSString stringWithFormat:@"%@%@", str, @"*"];
    }
    
    [self getModelListLimit:self.userLogin.user_id ByFlag:self.flag ByName:str ByPage:self.page];
    [_autoCompleter hideOptionsView];
    [self.modelConfigTableView reloadData];
}

-(IBAction)up:(id)sender
{
    
    
    NSString *str = nil;
    if (self.searchTextField.text.length != 0)
    {
        str = [NSString stringWithFormat:@"%@%@", @"*", self.searchTextField.text];
        str = [NSString stringWithFormat:@"%@%@", str, @"*"];
    }
    if (self.page == 0)
    {
        self.page = 0;
    }else
    {
        self.page = self.page - 1;
    }
    [self getModelListLimit:self.userLogin.user_id ByFlag:self.flag ByName:str ByPage:self.page];
    [self.modelConfigTableView reloadData];
}

-(IBAction)down:(id)sender
{
    NSString *str = nil;
    
    if (self.searchTextField.text.length != 0)
    {
        str = [NSString stringWithFormat:@"%@%@", @"*", self.searchTextField.text];
        str = [NSString stringWithFormat:@"%@%@", str, @"*"];
    }
    
    if([self.userLogin.modelList count] < 20)
    {
        self.page = 0;
    }else
    {
        self.page = self.page + 1;
    }
    [self getModelListLimit:self.userLogin.user_id ByFlag:self.flag ByName:str ByPage:self.page];
    [self.modelConfigTableView reloadData];
}

@end
