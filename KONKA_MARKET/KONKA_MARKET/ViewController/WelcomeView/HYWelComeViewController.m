//
//  HYViewController.m
//  KONKA_MARKET
//
//  Created by 许 玮 on 13-12-2.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYWelComeViewController.h"
#import "DataProcessing.h"
#import "SDImageView+SDWebCache.h"
#import "HYConstants.h"
#import "HYLoginViewController.h"
#import "WZGuideViewController.h"

@interface HYWelComeViewController ()

@end

@implementation HYWelComeViewController
@synthesize defaultView;
@synthesize versionView;
@synthesize lblTips;
@synthesize lblVersion;

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
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"getJson",@"method",@"1103",@"type_id",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:HomeImageApi]];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) endRequest:(NSString *)msg
{
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *json = [decoder objectWithData:data];
    NSDictionary *dic = [json objectAtIndex:0];
    NSString *strUrl = [dic objectForKey:@"image_path"];
    NSLog(@"strUrl: %@", strUrl);
    NSURL *url = [[NSURL alloc] initWithString:strUrl];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    defaultView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, screenBounds.size.width, screenBounds.size.height-120)];
    [defaultView setImageWithURL:url];
    
    
    //添加logo
    UIView *_view = [[UIView alloc] initWithFrame:CGRectMake(0, screenBounds.size.height - 120, screenBounds.size.width, 120)];
    _view.backgroundColor = [UIColor whiteColor];
    
    versionView  = [[UIImageView alloc]initWithFrame:CGRectMake(65,screenBounds.size.height - 80, 189, 24)];
    [versionView setImage:[UIImage imageNamed:@"loginlogo"]];
    
    lblTips = [[UILabel alloc] initWithFrame:CGRectMake(65, screenBounds.size.height - 55, 230, 24)];
    lblTips.text = @"渠道管理信息系统@多媒体渠道管理部";
    lblTips.font =  [UIFont fontWithName:@"Helvetica" size:11];
    lblTips.textColor = [UIColor underPageBackgroundColor];
    
    lblVersion = [[UILabel alloc] initWithFrame:CGRectMake(190, screenBounds.size.height - 20, 230, 24)];
    lblVersion.font =  [UIFont fontWithName:@"Helvetica" size:9];
    lblVersion.text = DevVersion;
    lblVersion.textColor = [UIColor underPageBackgroundColor];
    
    
    [self.view addSubview:defaultView];
    [self.view addSubview:_view];
    [self.view addSubview:versionView];
    [self.view addSubview:lblTips];
    [self.view addSubview:lblVersion];
    
    [NSTimer scheduledTimerWithTimeInterval:7.0f
                                     target:self
                                   selector:@selector(delayMethod)
                                   userInfo:nil
                                    repeats:NO];

}

-(void) delayMethod
{
    HYLoginViewController *loginView = [[HYLoginViewController alloc]initWithNibName:@"HYLoginViewController" bundle:nil];
    
    [self.navigationController pushViewController:loginView animated:YES];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [WZGuideViewController show];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

-(void) endFailedRequest:(NSString *)msg
{
    [super errorMsg:@"网络有问题！请联系客服！"];
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(delayMethod)
                                   userInfo:nil
                                    repeats:NO];
    return;
}

@end
