//
//  HYDataSubmitViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-18.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYTableViewCell.h"
#import "AutocompletionTableView.h"

@interface HYDataSubmitViewController : HYBaseViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,HYTableViewCell,AutocompletionTableViewDelegate>{

}

// Creates a textfield with the specified text and placeholder text
-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  ;

// Handles UIControlEventEditingDidEndOnExit
- (IBAction)textFieldFinished:(id)sender;

@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic, strong) UITableView *dropTableView;
@property (nonatomic, strong) UITableView *dropDownTableView;
@property (strong, nonatomic) IBOutlet UIImageView *uibgLabel;

- (IBAction)hisAction:(id)sender;

@end
