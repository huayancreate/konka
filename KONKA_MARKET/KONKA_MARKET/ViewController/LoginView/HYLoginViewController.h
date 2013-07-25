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

@property (weak, nonatomic) IBOutlet UITextField *uiUsername;

@property (weak, nonatomic) IBOutlet UITextField *uiPassword;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIImageView *uiremember;

@property (nonatomic) Boolean flag;

@property (weak,nonatomic) NSString *userName;
@property (weak,nonatomic) NSString *password;

@property (strong, nonatomic)  NSMutableArray *imgArray;

@end
