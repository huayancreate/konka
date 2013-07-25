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


@end

@implementation HYDataSubmitViewController
@synthesize cellLabel;
@synthesize cellTextField;
@synthesize mainTableView;
@synthesize LabelTextTableViewCell;
@synthesize cellImage;
@synthesize cellLabel1;
@synthesize dropTableView;
@synthesize cellLabel2;
@synthesize cellLabel3;


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
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, 340) style:UITableViewStyleGrouped];
    mainTableView.scrollEnabled = YES;
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    [self.view addSubview:mainTableView];
    
    UIView *tempView = [[UIView alloc] init];
    [mainTableView setBackgroundView:tempView];
    
    
    
    
    UIImage *backButtonImage = [UIImage imageNamed:@"conform.png"];
    CGRect frameimg = CGRectMake(0, 0, 20, 24);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    
    [someButton addTarget:self action:@selector(submit:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem  = rightButton;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    [self getStoreList:self.userLogin.user_id];
    
   
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
    return 5;
}

-(HYTableViewCell *) createTabelViewCellForIndentifier: (NSString *) indentifier NibNamed: (NSString *) nibName tableView:(UITableView *)tableView index:(int) index{

    HYTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier: indentifier];
    if (cell == nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];
        cell = [nib objectAtIndex:index];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (tableView == mainTableView) {
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        cell = [self createTabelViewCellForIndentifier:@"DropDownCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:2];
                        
                        [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
                        
                        self.cellLabel2.text = @"门店";
                        return cell;
                        break;
                    case 1:
                        break;
                    case 2:
                        cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
                        
                        [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];

                        self.cellLabel.text = @"型号";
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

-(void)scanCamera:(UIGestureRecognizer *)gestureRecognizer
{
//    ZBarReaderViewController *reader = [ZBarReaderViewController new];
//    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//    
//    ZBarImageScanner *scanner = reader.scanner;
//    // TODO: (optional) additional reader configuration here
//    
//    // EXAMPLE: disable rarely used I2/5 to improve performance
//    [scanner setSymbology: ZBAR_I25
//                   config: ZBAR_CFG_ENABLE
//                       to: 0];
//    
//    // present and release the controller
//    [self presentModalViewController: reader
//                            animated: YES];
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}

// Textfield value changed, store the new value.
- (void)textFieldDidEndEditing:(UITextField *)textField {

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
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

-(void)hidenKeyboard
{
    [self resumeView];
}

@end
