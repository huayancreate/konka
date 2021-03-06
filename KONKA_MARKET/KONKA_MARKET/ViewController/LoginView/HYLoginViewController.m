//
//  HYLoginViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-3.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYLoginViewController.h"
#import "HYHomeViewController.h"
#import "KonkaManager.h"
#import "WZGuideViewController.h"

@interface HYLoginViewController ()
{
    JSONDecoder* decoder;
    NSNumber * user_id;
}

@end

@implementation HYLoginViewController
@synthesize userName;
@synthesize password;
@synthesize imgArray;
@synthesize flag;
@synthesize uiPassword;
@synthesize uiUsername;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        imgArray = [[NSMutableArray alloc] initWithObjects:
                    [UIImage imageNamed:@"rememberset"],
                    [UIImage imageNamed:@"rememberunset"],nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 初始化照片列表
    
    decoder = [[JSONDecoder alloc] init];
    self.kkM = [[KonkaManager alloc] init];
    
    
    self.uiUsername.delegate = self;
    
    self.uiPassword.delegate = self;
    
    self.flag = false;
    
    [self.uiremember setImage:[imgArray objectAtIndex:0]];
    
    self.uiPassword.secureTextEntry = YES;
    
    UIImageView *imgvpass=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
    self.uiPassword.leftView = imgvpass;
    self.uiPassword.rightViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imguser=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"username"]];
    self.uiPassword.leftView = imguser;
    self.uiPassword.rightViewMode = UITextFieldViewModeAlways;
    
    self.uiremember.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.uiremember addGestureRecognizer:singleTap];
    
    self.uirememberLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.uirememberLabel addGestureRecognizer:singleTap1];
    
    self.uiHelperLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *help = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHelp:)];
    [self.uiHelperLabel addGestureRecognizer:help];
    
    //UIImage *loginBtnView = [UIImage imageNamed:@"loginbtn"];
    //self.loginBtn.imageView.image = loginBtnView;
    
    //TODO 读取最后一个用户名
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userDefaults stringForKey:@"user_name"];
    
    
    if ([str length] != 0)
    {
        NSString *thePassword = [[NSUserDefaults standardUserDefaults] objectForKey:str];
//        self.uiPassword.text = thePassword;
        if ([thePassword length] !=0){
            self.flag = !self.flag;
            [self.uiremember setImage:[imgArray objectAtIndex:0]];
        }
    }
    
    self.userName = self.uiUsername.text;
    self.password = self.uiPassword.text;
    
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHandle:)];
    [self.view addGestureRecognizer:singleTap2];

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

-(void)handleHelp:(UIGestureRecognizer *)gestureRecognizer
{
    [WZGuideViewController show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alttextFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField == self.uiUsername)
    {
        self.userName = self.uiUsername.text;
        
        NSString *msg = self.uiUsername.text;
        
        NSLog(@"username = %@", msg);
        if ([msg length] != 0){
            NSLog(@"username = %@", msg);
            NSString *thePassword = [[NSUserDefaults standardUserDefaults] objectForKey:msg];
            NSLog(@"userpass = %@",thePassword);
            self.uiPassword.text = thePassword;
        }
        
        [self.uiPassword becomeFirstResponder];
    }
    
}

- (IBAction)login:(id)sender
{
    if(![self checkTextisNull])
    {
        return;
    }
    [self checkUsernamePassword];
    [SVProgressHUD showWithStatus:@"正在进行系统登陆..." maskType:SVProgressHUDMaskTypeGradient];
}


-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}


-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [super errorMsg:msg];
}

-(void) endRequest:(NSString *)msg
{
    NSLog(@"MSG endRequest%@",msg );
    [SVProgressHUD dismiss];
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [decoder objectWithData:data];
    
    //[HYAppUtily stringOutputForDictionary:json];
    NSNumber *status = [json objectForKey:@"status"];
    NSNumber *success = [NSNumber numberWithLong:0];
    
    if (status == success){
        [self rememberMe];
        [SVProgressHUD showWithStatus:@"正在获取基础数据..." maskType:SVProgressHUDMaskTypeGradient];
        
        NSDictionary *userJSON = [json objectForKey:@"user"];

        //TODO 判断userID数据
        
        NSString *dataPatch = nil;
        NSNumber *type = nil;
        NSString *methodName = nil;
        
        user_id = [userJSON objectForKey:@"id"];
        
        if (![self.kkM isExistUserDataByID:user_id])
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
            
            [self.kkM insertUserDataByParems:dicuser];
            [self setUserLoginInfo:userJSON];
            
            dataPatch = @"1";
            type = [NSNumber numberWithInt:0];
            methodName = @"newDataNow";
            
            NSLog(@"self.userLogin.user_name %@",self.userLogin.user_name);
            [self loadBaseDataByDataPatch:dataPatch ByType:type ByMethodName:methodName];
            
            NSLog(@"插入数据");
            
        }else{
            // 如果有userID,更新部分数据
            [self.kkM updateUserInfoByUserID:user_id UserName:[userJSON objectForKey:@"user_name"] RealName:[userJSON objectForKey:@"real_name"] Sid:[userJSON objectForKey:@"sid"] department:[userJSON objectForKey:@"department"]];
            NSString *selectDataPatch = [self.kkM selectDataPatchByUserID:user_id];
            
            NSLog(@"selectDataPatch %@", selectDataPatch);
            // 获取本地dataPatch和网络dataPatch比较
            // 相等获取type = 1 newData
            // 不相等 更新本地数据 newDataNow type=0
            type = [NSNumber numberWithInt:0];
            methodName = @"newDataNow";
            
            NSLog(@"userJSON objectForKey:@user_name %@",[userJSON objectForKey:@"user_name"]);

            [self setUserLoginInfo:userJSON];
            
            NSLog(@"self.userLogin.user_name %@",self.userLogin.user_name);
            
            [self loadBaseDataByDataPatch:selectDataPatch ByType:type ByMethodName:methodName];
            
            NSLog(@"更新数据数据");
        }
        
        
    }else{
        [SVProgressHUD dismiss];
        [super errorMsg:[json objectForKey:@"msg"]];
    }
}

-(void) setUserLoginInfo:(NSDictionary *)userJSON
{
    self.userLogin.user_id = [userJSON objectForKey:@"id"];
    self.userLogin.user_name = [userJSON objectForKey:@"user_name"];
    self.userLogin.real_name = [userJSON objectForKey:@"real_name"];
    self.userLogin.department = [userJSON objectForKey:@"department"];
    self.userLogin.mobile_user_type = [userJSON objectForKey:@"mobile_user_type"];
    self.userLogin.password = self.uiPassword.text;
}

-(BOOL) checkTextisNull
{
    if( self.uiUsername.text.length == 0){
        //TOD 弹出警告
        NSString *msg = @"用户名不能为空！";
        [super errorMsg:msg];
        return false;
    }
    if( self.uiPassword.text.length == 0){
        //TOD 弹出警告
        NSString *msg = @"密码不能为空！";
        [super errorMsg:msg];
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
    [self.locManager startUpdatingLocation];
    
    NSLog(@"endLoadBaseDataRequest %@",msg);
    if (msg.length == 0){
        [SVProgressHUD dismiss];
        NSLog(@"dataPatch exist");
        HYHomeViewController *homeview = [[HYHomeViewController alloc] init];
        
        homeview.userLogin = self.userLogin;
        
        NSLog(@"homeview.userLogin %@",homeview.userLogin.user_name);
        
        [self.navigationController pushViewController:homeview animated:YES];
        return;
    }else{
        // 设置BaseData
        
        // 删除BaseDataByUserID
        
        //TODO 重构插入
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json = [decoder objectWithData:data];
        NSString* dataPatch = [json objectForKey:@"dataPatch"];
        NSLog(@"remote dataPatch %@",dataPatch);
        [self.kkM updateDataPatch:dataPatch ByUserID:user_id];
        
        [self.kkM deleteBaseDataByUserID:user_id];
        
        [self.kkM insertBaseDataByJson:msg ByUserID:self.userLogin.user_id];
        
        /*
        
        [self.kkM deleteAllBaseDataByUserID:user_id];
        
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* json = [decoder objectWithData:data];
        
//        NSArray* backList = [json objectForKey:@"backList"];
        NSArray* brandList = [json objectForKey:@"brandList"];
//        NSArray* goodList = [json objectForKey:@"goodList"];
//        NSArray* ideaList = [json objectForKey:@"ideaList"];
        NSArray* modelList = [json objectForKey:@"modelList"];
        NSArray* peList = [json objectForKey:@"peList"];
//        NSArray* plList = [json objectForKey:@"plList"];
        NSArray* storeList = [json objectForKey:@"storeList"];
        
        
        
//        [self runLoopSets:backList Type:@"backList" UserID:user_id];
        [self runLoopSets:brandList Type:@"brandList" UserID:user_id];
//        [self runLoopSets:goodList Type:@"goodList" UserID:user_id];
//        [self runLoopSets:ideaList Type:@"ideaList" UserID:user_id];
        [self runLoopSets:modelList Type:@"modelList" UserID:user_id];
        [self runLoopSets:peList Type:@"peList" UserID:user_id];
//        [self runLoopSets:plList Type:@"plList" UserID:user_id];
        [self runLoopSets:storeList Type:@"storeList" UserID:user_id];
        
        
        NSString* dataPatch = [json objectForKey:@"dataPatch"];
        NSLog(@"remote dataPatch %@",dataPatch);
        [self.kkM updateDataPatch:dataPatch ByUserID:user_id];
         */
        
        NSLog(@"BASE INSERT");
        
        //TODO 存储数据
        [SVProgressHUD dismiss];
        
        HYHomeViewController *homeview = [[HYHomeViewController alloc] init];
        
        homeview.userLogin = self.userLogin;
        NSLog(@"homeview.userLogin.storeList %d",[homeview.userLogin.storeList count]);
        
        NSLog(@"homeview.userLogin %@",homeview.userLogin.user_name);
        
        [self.navigationController pushViewController:homeview animated:YES];
    }
}

//-(void) runLoopSets:(NSArray *)list Type:(NSString *)type UserID:(NSNumber *) userid
//{
//    NSMutableDictionary *dicBase = [[NSMutableDictionary alloc] init];
//
//    for(NSDictionary *innerObj in list)
//    {
//        NSNumber *flagNumber = [[NSNumber alloc] initWithInt:0];
//        [dicBase setValue:[innerObj objectForKey:@"addon1"] forKey:@"addon1"];
//        [dicBase setValue:[innerObj objectForKey:@"addon2"] forKey:@"addon2"];
//        [dicBase setValue:[innerObj objectForKey:@"id"] forKey:@"base_id"];
//        [dicBase setValue:[innerObj objectForKey:@"name"] forKey:@"name"];
//        [dicBase setValue:type forKey:@"list_type"];
//        [dicBase setValue:userid forKey:@"user_id"];
//        [dicBase setValue:flagNumber forKey:@"flag"];
//        [self.kkM insertBaseDataByParems:dicBase];
//    }
//}

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(!self.flag){
        
        //TOOD 记住密码
        [userDefaults removeObjectForKey:self.uiUsername.text];
        [userDefaults removeObjectForKey:@"user_name"];
        [userDefaults setObject:self.uiPassword.text forKey:self.uiUsername.text];
        [userDefaults setObject:self.uiUsername.text forKey:@"user_name"];

    }else{
        [userDefaults removeObjectForKey:@"user_name"];
        [userDefaults removeObjectForKey:self.uiUsername.text];
    }
}

@end
