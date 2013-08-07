//
//  HYLoginViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-3.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYLoginViewController : HYBaseViewController<UITextFieldDelegate>{
    NSMutableArray *imgArray;

}

-(IBAction)login:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *uiUsername;

@property (strong, nonatomic) IBOutlet UITextField *uiPassword;

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) IBOutlet UIImageView *uiremember;

@property (strong, nonatomic) IBOutlet UILabel *uirememberLabel;

@property (weak, nonatomic) IBOutlet UILabel *uiHelperLabel;


@property (nonatomic) Boolean flag;

@property (weak,nonatomic) NSString *userName;
@property (weak,nonatomic) NSString *password;

@property (strong, nonatomic)  NSMutableArray *imgArray;

@end
