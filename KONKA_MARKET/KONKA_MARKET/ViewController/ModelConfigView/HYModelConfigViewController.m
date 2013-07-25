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

-(void) getModelList:(NSNumber *)user_id ByFlag:(NSNumber *)flag ByName:(NSString *)name ByFirstFlag:(Boolean) firstFlag;
{
    KonkaManager *kkM = [[KonkaManager alloc] init];
    
    self.userLogin.modelList = [kkM getModelListByUserID:user_id ByType:@"modelList" ByFlag:flag ByName:name];
    self.userLogin.modelNameList = [[NSMutableArray alloc] init];
    if(firstFlag)
    {
        self.userLogin.modelNameCopyList = [[NSMutableArray alloc] init];
    }
    for (NSDictionary *dic in self.userLogin.modelList) {
        NSLog(@"[dic objectForKey:@name] %@", [dic objectForKey:@"name"]);
        [self.userLogin.modelNameList addObject:[NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]]];
        if(firstFlag)
        {
            [self.userLogin.modelNameCopyList addObject:[NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]]];
        }
        NSLog(@"self.userLogin.modelNameList %@", [self.userLogin.modelNameList objectAtIndex:0]);
    }
    NSLog(@"self.userLogin.modelNameList count %d", [self.userLogin.modelNameList count]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.flag = [[NSNumber alloc] initWithInt:0];
    
    [self getModelList:self.userLogin.user_id ByFlag:self.flag ByName:nil ByFirstFlag:true];
    

        
    modelConfigTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, 320, 260) style:UITableViewStyleGrouped];
    
    modelConfigTableView.delegate = self;
    modelConfigTableView.dataSource = self;
    
    modelConfigTableView.scrollEnabled = YES;
    
    UIView *tempView = [[UIView alloc] init];
    
    [modelConfigTableView setBackgroundView:tempView];
    
    [self.view addSubview:modelConfigTableView];
    
    [self.searchTextField addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.searchTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.uiModelSet setBackgroundColor:[UIColor blueColor]];
    [self.uiModelSet.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiUnModelSet.titleLabel setTextColor:[UIColor blackColor]];
    
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldDidEndEditing:(id)sender
{
    
}

-(IBAction)modelSetAction:(id)sender
{
    self.flag = [[NSNumber alloc] initWithInt:0];
    
    NSString *name = nil;
    if (self.searchTextField.text.length != 0)
    {
        name = [NSString stringWithFormat:@"%@%@", @"*", self.searchTextField.text];
        name = [NSString stringWithFormat:@"%@%@", name, @"*"];
    }
    
    [self getModelList:self.userLogin.user_id ByFlag:self.flag ByName:name ByFirstFlag:YES];
    
    [self.uiModelSet setBackgroundColor:[UIColor blueColor]];
    
    [self.uiUnModelSet setBackgroundColor:[UIColor clearColor]];
    
    [self.uiModelSet.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiUnModelSet.titleLabel setTextColor:[UIColor blackColor]];
    
    [self.modelConfigTableView reloadData];
}

-(IBAction)unmModelSetAction:(id)sender
{
    
    self.flag = [[NSNumber alloc] initWithInt:1];
    
    NSString *name = nil;
    
    if (self.searchTextField.text.length != 0)
    {
        name = [NSString stringWithFormat:@"%@%@", @"*", self.searchTextField.text];
        name = [NSString stringWithFormat:@"%@%@", name, @"*"];
    }
    
    [self getModelList:self.userLogin.user_id ByFlag:self.flag ByName:name ByFirstFlag:YES];
    
    [self.uiModelSet setBackgroundColor:[UIColor clearColor]];
    
    [self.uiUnModelSet setBackgroundColor:[UIColor blueColor]];
    
    [self.uiModelSet.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiUnModelSet.titleLabel setTextColor:[UIColor blackColor]];
    
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
    static NSString *CustomCellIdentifier =@"ModelCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
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
    UIButton *btnTag = (UIButton *)sender;
    NSString *name = [self.userLogin.modelNameList objectAtIndex:btnTag.tag];
    
    NSString *str = nil;
    
    if (self.searchTextField.text.length != 0)
    {
        str = [NSString stringWithFormat:@"%@%@", @"*", self.searchTextField.text];
        str = [NSString stringWithFormat:@"%@%@", str, @"*"];
    }
    
    KonkaManager *kkM = [[KonkaManager alloc] init];
    
   
    [kkM updateModelListByName:name ByUserID:self.userLogin.user_id];
    
    [self getModelList:self.userLogin.user_id ByFlag:self.flag ByName:str ByFirstFlag:true];
    
    [self.modelConfigTableView reloadData];

}

-(IBAction)search:(id)sender
{
    if (self.searchTextField.text.length == 0){
        [super alertMsg:@"搜索内容不能为空！" forTittle:@"提示"];
        return;
    }

    NSLog(@"self.searchTextField.text %@",self.searchTextField.text);
    
    NSString *str = nil;
    
    str = [NSString stringWithFormat:@"%@%@", @"*", self.searchTextField.text];
    str = [NSString stringWithFormat:@"%@%@", str, @"*"];
    
    [self getModelList:self.userLogin.user_id ByFlag:self.flag ByName:str ByFirstFlag:false];
    [_autoCompleter hideOptionsView];
    [self.modelConfigTableView reloadData];
}

-(IBAction)up:(id)sender
{
//    [self.modelConfigTableView scrollToRowAtIndexPath:10
//                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(IBAction)down:(id)sender
{
//    [self.modelConfigTableView scrollToRowAtIndexPath:10
//                                     atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
