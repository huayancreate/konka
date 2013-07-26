//
//  HYPasswordConfigViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-19.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYPasswordConfigViewController.h"

@interface HYPasswordConfigViewController ()

@end

@implementation HYPasswordConfigViewController
@synthesize cellLabel;
@synthesize cellTextField;
@synthesize mainTabelView;
@synthesize LabelTextTableViewCell;
@synthesize cellImage;
@synthesize cellLabel1;
@synthesize uinewpassword;
@synthesize uirepeatpassword;
@synthesize cellLabel2;
@synthesize cellLabel3;
@synthesize cellLabel4;

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
    
    UIImage *setConfigImage = [UIImage imageNamed:@"conform.png"];
    CGRect frameimg = CGRectMake(0, 20, 30, 30);
    UIButton *configButton = [[UIButton alloc] initWithFrame:frameimg];
    [configButton setBackgroundImage:setConfigImage forState:UIControlStateNormal];
    
    [configButton addTarget:self action:@selector(submit:)
           forControlEvents:UIControlEventTouchUpInside];
    [configButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:configButton];
    
    
    self.navigationItem.rightBarButtonItem  = rightButton;
    
    UIView *tempView = [[UIView alloc] init];
    [self.mainTabelView setBackgroundView:tempView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)submit:(id)sender
{
    if(![self checkTextisNull])
    {
        return;
    }
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:@"ModifyPass",@"method",self.userLogin.user_name,@"username",self.userLogin.password,@"userpass",uinewpassword.text, @"new_userpass",uirepeatpassword.text, @"new_userpass_r",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:DataSubmitApi]];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}


-(BOOL) checkTextisNull
{
    if( self.uinewpassword.text.length == 0){
        //TOD 弹出警告
        NSString *msg = @"新密码不能为空！";
        [super alertMsg:msg forTittle:@"输入错误"];
        return false;
    }
    if( self.uirepeatpassword.text.length == 0){
        //TOD 弹出警告
        NSString *msg = @"确认密码不能为空！";
        [super alertMsg:msg forTittle:@"输入错误"];
        return false;
    }
    if( ![self.uirepeatpassword.text isEqualToString:self.uinewpassword.text]){
        //TOD 弹出警告
        NSString *msg = @"密码不相同！";
        [super alertMsg:msg forTittle:@"输入错误"];
        return false;
    }
    return true;
}

-(void)endRequest:(NSString *)msg
{
    self.newpassword = self.uirepeatpassword.text;
    self.userLogin.password = self.newpassword;
    if ([msg isEqualToString:@"success"])
    {
        [super alertMsg:@"修改成功" forTittle:@"修改密码"];
    }else
    {
        [super alertMsg:msg forTittle:@"修改密码"];
    }
    
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
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
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
            cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];

            self.cellLabel.text = @"用户名";
            NSLog(@"系统设置 %@", self.userLogin.user_name);
            self.cellTextField.text = self.userLogin.user_name;
            self.cellTextField.enabled = NO;
            return cell;
            break;
        case 1:
            cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
            
            [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
            self.cellLabel.text = @"新密码";
            self.uinewpassword = self.cellTextField;
            [self.uinewpassword setSecureTextEntry:YES];
            return cell;
            break;
        case 2:
            cell = [self createTabelViewCellForIndentifier:@"LabelTextCellIdentifier" NibNamed:@"HYTableViewCell" tableView:tableView index:0];
            
            [self.cellTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
            self.cellLabel.text = @"确认密码";
            self.uirepeatpassword = self.cellTextField;
            [self.uirepeatpassword setSecureTextEntry:YES];
            return cell;
            break;
        }
}

-(void) textFieldFinished:(id)sender{

}

@end
