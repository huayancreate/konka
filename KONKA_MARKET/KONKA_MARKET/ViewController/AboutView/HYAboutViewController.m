//
//  HYAboutViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-7-26.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYAboutViewController.h"

@interface HYAboutViewController ()
@property (strong, nonatomic) IBOutlet UILabel *uiLabelDevVersion;

@end

@implementation HYAboutViewController

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
    self.uiLabelDevVersion.text = DevVersion;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
