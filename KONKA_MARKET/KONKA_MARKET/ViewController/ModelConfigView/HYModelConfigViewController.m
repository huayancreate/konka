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

@end

@implementation HYModelConfigViewController
@synthesize modelConfigTableView;
@synthesize tableViewCell;
@synthesize searchTextField = _textField;
@synthesize autoCompleter = _autoCompleter;
@synthesize uiLableModelName;

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

-(void) getStoreList:(NSNumber *)user_id
{
    KonkaManager *kkM = [[KonkaManager alloc] init];
    
    self.userLogin.modelList = [kkM getStoreListByUserID:user_id ByType:@"modelList"];
    self.userLogin.modelNameList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in self.userLogin.modelList) {
        NSLog(@"[dic objectForKey:@name] %@", [dic objectForKey:@"name"]);
        [self.userLogin.modelNameList addObject:[NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]]];
        NSLog(@"self.userLogin.modelNameList %@", [self.userLogin.modelNameList objectAtIndex:0]);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getStoreList:self.userLogin.user_id];
    

        
    modelConfigTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, 320, 260) style:UITableViewStyleGrouped];
    
    modelConfigTableView.delegate = self;
    modelConfigTableView.dataSource = self;
    
    modelConfigTableView.scrollEnabled = YES;
    
    UIView *tempView = [[UIView alloc] init];
    
    [modelConfigTableView setBackgroundView:tempView];
    
    [self.view addSubview:modelConfigTableView];
    
    [self.searchTextField addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.uiModelSet setBackgroundColor:[UIColor blueColor]];
    [self.uiModelSet.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiUnModelSet.titleLabel setTextColor:[UIColor blackColor]];
    
}

-(IBAction)modelSetAction:(id)sender
{
    [self.uiModelSet setBackgroundColor:[UIColor blueColor]];
    
    [self.uiUnModelSet setBackgroundColor:[UIColor clearColor]];
    
    [self.uiModelSet.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiUnModelSet.titleLabel setTextColor:[UIColor blackColor]];
}

-(IBAction)unmModelSetAction:(id)sender
{
    
    [self.uiModelSet setBackgroundColor:[UIColor clearColor]];
    
    [self.uiUnModelSet setBackgroundColor:[UIColor blueColor]];
    
    [self.uiModelSet.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiUnModelSet.titleLabel setTextColor:[UIColor blackColor]];

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
    cell = [nib objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    uiLableModelName.text = [self.userLogin.modelNameList objectAtIndex:indexPath.row];
    return  cell;
}

#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return self.userLogin.modelNameList;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index{
    // invoked when an available suggestion is selected
    NSLog(@"%@ - Suggestion chosen: %d", completer, index);
}


@end
