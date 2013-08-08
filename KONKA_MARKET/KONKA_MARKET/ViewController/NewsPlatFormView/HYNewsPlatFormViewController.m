//
//  HYNewsPlatFormViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-8-7.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYNewsPlatFormViewController.h"
#import "TopScrollView.h"
#import "RootScrollView.h"
#import "Globle.h"

@interface HYNewsPlatFormViewController()

@end

@implementation HYNewsPlatFormViewController

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
	// Do any additional setup after loading the view.
    //UIImageView *setButtonShadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(258, 0, 22, 44)];
    //setButtonShadowImageView.image = [UIImage imageNamed:@"top_channelbutton_shadow.png"];
//    setButtonShadowImageView.userInteractionEnabled = YES;
//    [self.view addSubview:setButtonShadowImageView];
    //[setButtonShadowImageView release];
    
    UIImageView *topShadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 5)];
    [topShadowImageView setImage:[UIImage imageNamed:@"top_background_shadow.png"]];
    [self.view addSubview:topShadowImageView];
    //[topShadowImageView release];
    //[RootScrollView shareInstance].userlogin = self.userLogin;
    //[[RootScrollView shareInstance] start];

    
    [self.view addSubview:[TopScrollView shareInstance]];
    [self.view addSubview:[RootScrollView shareInstance:self.userLogin.user_name Password:self.userLogin.password]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
