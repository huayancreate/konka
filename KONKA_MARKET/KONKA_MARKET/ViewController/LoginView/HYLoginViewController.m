//
//  HYLoginViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-3.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYLoginViewController.h"
#import "HYHomeViewController.h"
#import "SFHFKeychainUtils.h"
#import "KonkaManager.h"

@interface HYLoginViewController ()
{
    JSONDecoder* decoder;
    NSNumber * user_id;
    KonkaManager *kkM;
}

@end

@implementation HYLoginViewController
@synthesize userName;
@synthesize password;
@synthesize imgArray;
@synthesize flag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        imgArray = [[NSMutableArray alloc] initWithObjects:
                    [UIImage imageNamed:@"remember1@x2.png"],
                    [UIImage imageNamed:@"remember2@x2.png"],nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 初始化照片列表
    
    decoder = [[JSONDecoder alloc] init];
    kkM = [[KonkaManager alloc] init];
    
    
    self.uiUsername.delegate = self;
    
    self.uiPassword.delegate = self;
    
    self.flag = true;
    
    
    self.uiPassword.secureTextEntry = YES;
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"注销";
    self.navigationItem.backBarButtonItem = backItem;
    
    UIImageView *imgvpass=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passwordimg"]];
    self.uiPassword.leftView = imgvpass;
    self.uiPassword.rightViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imguser=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userimg"]];
    self.uiPassword.leftView = imguser;
    self.uiPassword.rightViewMode = UITextFieldViewModeAlways;
    
    [self.uiUsername addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    [self.uiPassword addTarget:self action:@selector(userPasstextFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    
    
    self.uiremember.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.uiremember addGestureRecognizer:singleTap];
    
    
    //TODO 读取最后一个用户名
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userDefaults stringForKey:@"user_name"];
    
    
    
    NSError *localError;
    if ([str length] != 0)
    {
        NSString *thePassword = [SFHFKeychainUtils
                                 getPasswordForUsername:self.uiUsername.text
                                 andServiceName:ServiceName
                                 error:&localError];
        self.uiPassword.text = thePassword;
        if ([thePassword length] !=0){
            self.flag = !self.flag;
            [self.uiremember setImage:[imgArray objectAtIndex:0]];
        }
    }
    
    self.userName = self.uiUsername.text;
    self.password = self.uiPassword.text;
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];

}

-(void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    self.flag = !self.flag;
    if(self.flag){
        [self.uiremember setImage:[imgArray objectAtIndex:1]];
    }else{
        [self.uiremember setImage:[imgArray objectAtIndex:0]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    
    self.userName = self.uiUsername.text;
    
    NSError *localError;
    NSString *msg = self.uiUsername.text;
    
    if ([msg length] != 0){
        NSString *thePassword = [SFHFKeychainUtils getPasswordForUsername:msg
                                                    andServiceName:ServiceName
                                                    error:&localError];
        self.uiPassword.text = thePassword;
    }
    
    if (sender == self.uiUsername) {
        [self.uiPassword becomeFirstResponder];
    }else if (sender == self.uiPassword){
        [self hidenKeyboard];
    }
    
}

-(void)hidenKeyboard
{
    [self.uiUsername resignFirstResponder];
    [self.uiPassword resignFirstResponder];
    [self resumeView];
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)userPasstextFieldFinished:(id)sender {
    self.password = self.uiPassword.text;
    
    if(![self checkTextisNull])
     {
         if (sender == self.uiUsername) {
             [self.uiPassword becomeFirstResponder];
         }else if (sender == self.uiPassword){
             [self hidenKeyboard];
         }
         return;
     }
    
    if (sender == self.uiUsername) {
        [self.uiPassword becomeFirstResponder];
    }else if (sender == self.uiPassword){
        [self hidenKeyboard];
    }
    
    [self hudprogress];
     
}


- (IBAction)login:(id)sender
{
    if(![self checkTextisNull])
    {
        return;
    }
    
    [self hudprogress];
}

-(void) hudprogress
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    
    [self checkUsernamePassword];
	
	HUD.delegate = self;
	HUD.labelText = @"正在进行系统登陆";
	HUD.square = YES;
	
    [HUD show:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}


-(void) endFailedRequest:(NSString *)msg
{
    [HUD hide:YES];
    [super alertMsg:msg forTittle:@"错误"];
}

-(void) endRequest:(NSString *)msg
{
    NSLog(@"MSG endRequest%@",msg );
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [decoder objectWithData:data];
    
    NSNumber *status = [json objectForKey:@"status"];
    NSNumber *success = [NSNumber numberWithLong:0];
    
    if (status == success){
        [self rememberMe];
        HUD.labelText = @"正在获取基础数据";
        
        NSDictionary *userJSON = [json objectForKey:@"user"];

        //TODO 判断userID数据
        
        NSString *dataPatch = nil;
        NSNumber *type = nil;
        NSString *methodName = nil;
        
        user_id = [userJSON objectForKey:@"id"];
        
        if (![kkM isExistUserDataByID:user_id])
        {
            // 如果没有userID,插入数据
            // 获取最新BaseData newDataNow 保存数据 type=0
            NSMutableDictionary *dicuser = [[NSMutableDictionary alloc] init];
            
            [dicuser setValue:[userJSON objectForKey:@"user_name"] forKey:@"user_name"];
            [dicuser setValue:[userJSON objectForKey:@"real_name"] forKey:@"real_name"];
            [dicuser setValue:[userJSON objectForKey:@"id"] forKey:@"user_id"];
            [dicuser setValue:[userJSON objectForKey:@"sid"] forKey:@"sid"];
            [dicuser setValue:[userJSON objectForKey:@"dataPatch"] forKey:@"dataPatch"];
            [dicuser setValue:[userJSON objectForKey:@"department"] forKey:@"department"];
            
            [kkM insertUserDataByParems:dicuser];
            [self setUserLoginInfo:userJSON];
            
            dataPatch = @"1";
            type = [NSNumber numberWithInt:0];
            methodName = @"newDataNow";
            
            NSLog(@"self.userLogin.user_name %@",self.userLogin.user_name);
            [self loadBaseDataByDataPatch:dataPatch ByType:type ByMethodName:methodName];
            
            NSLog(@"插入数据");
            
        }else{
            // 如果有userID,更新部分数据
            NSString *selectDataPatch = [kkM selectDataPatchByUserID:user_id];
            NSLog(@"selectDataPatch %@", selectDataPatch);
            // 获取本地dataPatch和网络dataPatch比较
            // 相等获取type = 1 newData
            // 不相等 更新本地数据 newDataNow type=0
            type = [NSNumber numberWithInt:1];
            methodName = @"newDataNow";
            
            NSLog(@"userJSON objectForKey:@user_name %@",[userJSON objectForKey:@"user_name"]);

            [self setUserLoginInfo:userJSON];
            
            NSLog(@"self.userLogin.user_name %@",self.userLogin.user_name);
            
            [self loadBaseDataByDataPatch:selectDataPatch ByType:type ByMethodName:methodName];
            
            NSLog(@"更新数据数据");
        }
        
        
    }else{
        [HUD hide:YES];
        [super alertMsg:[json objectForKey:@"msg"] forTittle:@"消息"];
    }
}

-(void) setUserLoginInfo:(NSDictionary *)userJSON
{
    self.userLogin.user_id = [userJSON objectForKey:@"id"];
    self.userLogin.user_name = [userJSON objectForKey:@"user_name"];
    self.userLogin.real_name = [userJSON objectForKey:@"real_name"];
    self.userLogin.department = [userJSON objectForKey:@"department"];
    self.userLogin.password = self.uiPassword.text;
}

-(BOOL) checkTextisNull
{
    if( self.uiUsername.text.length == 0){
        //TOD 弹出警告
        NSString *msg = @"用户名不能为空！";
        [super alertMsg:msg forTittle:@"输入错误"];
        return false;
    }
    if( self.uiPassword.text.length == 0){
        //TOD 弹出警告
        NSString *msg = @"密码不能为空！";
        [super alertMsg:msg forTittle:@"输入错误"];
        return false;
    }
    return true;
}

-(void) checkUsernamePassword
{
    //TODO 验证密码
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.uiUsername.text,@"username",self.uiPassword.text,@"password",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:LoginApi]];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}

-(void) loadBaseDataByDataPatch:(NSString *)dataPatch ByType:(NSNumber *)type ByMethodName:(NSString *)methodName
{
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:methodName,@"method",self.uiUsername.text,@"username",self.uiPassword.text,@"userpass",dataPatch,@"dataPatch",type,@"type",nil];

    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:LoadDataApi]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
        
    }
    [request setDidFinishSelector:@selector(endLoadBaseDataFin:)];
    [request setDidFailSelector:@selector(endLoadBaseDataFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];

}


-(void) endLoadBaseDataRequest:(NSString *)msg
{
    
    NSLog(@"endLoadBaseDataRequest %@",msg);
    if (msg.length == 0){
        [HUD hide:YES];
        NSLog(@"dataPatch exist");
        HYHomeViewController *homeview = [[HYHomeViewController alloc] init];
        
        homeview.userLogin = self.userLogin;
        
        NSLog(@"homeview.userLogin %@",homeview.userLogin.user_name);
        
        [self.navigationController pushViewController:homeview animated:YES];
        return;
    }else{
        // 设置BaseData
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* json = [decoder objectWithData:data];
        
        NSArray* backList = [json objectForKey:@"backList"];
        NSArray* brandList = [json objectForKey:@"brandList"];
        NSArray* goodList = [json objectForKey:@"goodList"];
        NSArray* ideaList = [json objectForKey:@"ideaList"];
        NSArray* modelList = [json objectForKey:@"modelList"];
        NSArray* peList = [json objectForKey:@"peList"];
        NSArray* plList = [json objectForKey:@"plList"];
        NSArray* storeList = [json objectForKey:@"storeList"];
        
        [self runLoopSets:backList Type:@"backList" UserID:user_id];
        [self runLoopSets:brandList Type:@"brandList" UserID:user_id];
        [self runLoopSets:goodList Type:@"goodList" UserID:user_id];
        [self runLoopSets:ideaList Type:@"ideaList" UserID:user_id];
        [self runLoopSets:modelList Type:@"modelList" UserID:user_id];
        [self runLoopSets:peList Type:@"peList" UserID:user_id];
        [self runLoopSets:plList Type:@"plList" UserID:user_id];
        [self runLoopSets:storeList Type:@"storeList" UserID:user_id];
        
        
        NSString* dataPatch = [json objectForKey:@"dataPatch"];
        NSLog(@"remote dataPatch %@",dataPatch);
        [kkM updateDataPatch:dataPatch ByUserID:user_id];
        
        NSLog(@"BASE INSERT");
        
        //TODO 存储数据
        [HUD hide:YES];
        
        HYHomeViewController *homeview = [[HYHomeViewController alloc] init];
        
        homeview.userLogin = self.userLogin;
        
        NSLog(@"homeview.userLogin %@",homeview.userLogin.user_name);
        
        [self.navigationController pushViewController:homeview animated:YES];
    }
}

-(void) runLoopSets:(NSArray *)list Type:(NSString *)type UserID:(NSNumber *) userid
{
    NSMutableDictionary *dicBase = [[NSMutableDictionary alloc] init];

    for(NSDictionary *innerObj in list)
    {
        NSNumber *flagNumber = [[NSNumber alloc] initWithInt:0];
        [dicBase setValue:[innerObj objectForKey:@"addon1"] forKey:@"addon1"];
        [dicBase setValue:[innerObj objectForKey:@"addon2"] forKey:@"addon2"];
        [dicBase setValue:[innerObj objectForKey:@"id"] forKey:@"base_id"];
        [dicBase setValue:[innerObj objectForKey:@"name"] forKey:@"name"];
        [dicBase setValue:type forKey:@"list_type"];
        [dicBase setValue:userid forKey:@"user_id"];
        [dicBase setValue:flagNumber forKey:@"flag"];
        [kkM insertBaseDataByParems:dicBase];
    }
}

- (void) endLoadBaseDataFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endLoadBaseDataRequest:) withObject:responsestring waitUntilDone:YES];
    
    // 存储basedata
    
}

- (void) endLoadBaseDataFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败";
    [self performSelectorOnMainThread:@selector(endFailedRequest:) withObject:responsestring waitUntilDone:YES];
}

-(void) rememberMe
{
    //TODO 是否记住密码
    
    NSError *localError = nil;
    if(!self.flag){
        
        NSLog(@"记住密码 %@",@"111");
        //TOOD 记住密码
        [SFHFKeychainUtils storeUsername:self.uiUsername.text andPassword:self.uiPassword.text forServiceName:ServiceName updateExisting:1 error:&localError];
        
        
        
        //TODO 验证
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.uiUsername.text forKey:@"user_name"];

    }else{
        NSLog(@"没有记住密码 %@",@"111");
        [SFHFKeychainUtils deleteItemForUsername:self.uiUsername.text andServiceName:ServiceName error:&localError];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"user_name"];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-20,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
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

@end
