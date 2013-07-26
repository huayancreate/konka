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

#define NUMBERS @".0123456789\n"


@interface HYDataSubmitViewController ()
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic, strong) UITextField *theTextField;
@property (nonatomic, strong) UILabel *storeName;


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
@synthesize theTextField = _textField;
@synthesize autoCompleter = _autoCompleter;
@synthesize storeName;
@synthesize uibgLabel;

- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.theTextField inViewController:self withOptions:options];
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
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 340) style:UITableViewStyleGrouped];
    mainTableView.scrollEnabled = YES;
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    [self.view addSubview:mainTableView];
    
    UIView *tempView = [[UIView alloc] init];
    [mainTableView setBackgroundView:tempView];
    
    
    
    
    UIImage *backButtonImage = [UIImage imageNamed:@"right.png"];
    CGRect frameimg = CGRectMake(0, 0, 20, 24);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    
    [someButton addTarget:self action:@selector(submit:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem  = rightButton;
    
    self.uibgLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard:)];
    gesture.numberOfTapsRequired = 1;
    [self.uibgLabel addGestureRecognizer:gesture];
    
    [self getStoreList:self.userLogin.user_id];
    
    NSNumber *flag = [[NSNumber alloc] initWithInt:1];
    [self getAllModelNameList:self.userLogin.user_id ByFlag:flag];
    
    CGRect textFieldRect = CGRectMake(120, 145, 175, 30);
    self.theTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    
    [self.theTextField addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.theTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    CGRect labelFieldRect = CGRectMake(0, 0, 175, 30);
    
    storeName = [[UILabel alloc] initWithFrame:labelFieldRect];
    
    NSDictionary *dic = [self.userLogin.storeList objectAtIndex:0];
    storeName.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = nil;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeSelectAction:)];
    [storeName addGestureRecognizer:singleTap];
    storeName.text = [dic objectForKey:@"name"];
    
   
}


-(void) getAllModelNameList:(NSNumber *)user_id ByFlag:(NSNumber *)flag
{
    KonkaManager *kkM = [[KonkaManager alloc] init];
    self.userLogin.modelNameStoreList = [kkM getAllModelNameListByUserID:user_id ByFlag:flag];
    NSLog(@"getAllModelNameList %d" , [self.userLogin.modelNameStoreList count]);
}

- (void) getStoreList:(NSNumber *)user_id
{
    NSLog(@"getStoreList user_id %d", [user_id intValue]);
    KonkaManager *kkM = [[KonkaManager alloc] init];
    
    NSNumber *flag = [[NSNumber alloc] initWithInt:0];
    
    self.userLogin.storeList = [kkM getStoreListByUserID:user_id ByType:@"storeList" ByFlag:flag];
}


- (void) submit:(id)sender
{
    
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

-(void)storeSelectAction:(UIGestureRecognizer *)gestureRecognizer
{
    dropDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(107, 90, 175, 132) style:UITableViewStylePlain];
    dropDownTableView.scrollEnabled = YES;
    
    dropDownTableView.delegate = self;
    dropDownTableView.dataSource = self;
    
    [self.view addSubview:dropDownTableView];
    
    UIView *tempView = [[UIView alloc] init];
    [dropDownTableView setBackgroundView:tempView];

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    NSDictionary *dic = (NSDictionary *)[self.userLogin.storeList objectAtIndex:0];
    
    if (tableView == dropDownTableView)
    {
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
                        cell.accessoryView = self.theTextField;
                        self.cellLabel4.text = @"型号";
                        return cell;
                        break;
                    case 3:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
                        
                        [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
                        self.cellLabel.text = @"数量";
                        return cell;
                        break;
                    case 4:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
                        
                        [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
                        self.cellLabel.text = @"单价";
                        return cell;
                        break;
                    case 5:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
                        
                        [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
                        self.cellLabel.text = @"金额";
                        return cell;
                        break;
                    case 6:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
                        
                        [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
                        self.cellLabel.text = @"备注";
                        return cell;
                        break;
                }
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
                        
                        [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
                        self.cellLabel.text = @"顾客姓名";
                        return cell;
                        break;
                    case 1:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
                        
                        [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
                        self.cellLabel.text = @"顾客电话";
                        return cell;
                        break;
                    case 2:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
                        
                        [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
                        self.cellLabel.text = @"顾客地址";
                        return cell;
                        break;
                    case 3:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
                        
                        [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
                        self.cellLabel.text = @"顾客身份证";
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
            
            self.cellImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanCamera:)];
            [self.cellImage addGestureRecognizer:singleTap];
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


-(void)alertTest:(id) sender
{
    [super alertMsg:@"111" forTittle:@"111"];
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

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {

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

//- (void) imagePickerController: (UIImagePickerController*) reader
// didFinishPickingMediaWithInfo: (NSDictionary*) info
//{
//    // ADD: get the decode results
//    id<NSFastEnumeration> results =
//    [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        // EXAMPLE: just grab the first barcode
//        break;
//    
//    // EXAMPLE: do something useful with the barcode data
//    //resultText.text = symbol.data;
//    
//    // EXAMPLE: do something useful with the barcode image
//    //resultImage.image =
//    //[info objectForKey: UIImagePickerControllerOriginalImage];
//    
//    // ADD: dismiss the controller (NB dismiss from the *reader*!)
//    [[reader presentingViewController] dismissViewControllerAnimated:YES completion:nil];
//}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return(YES);
}


- (IBAction)hisAction:(id)sender{

    HYSalesRegistrationViewController *srView = [[HYSalesRegistrationViewController alloc] init];
    
    srView.title = @"上报历史";
    [self.navigationController pushViewController:srView animated:YES];
}

-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

-(void)hidenKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //[self resumeView];
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
