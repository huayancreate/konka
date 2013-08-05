//
//  HYPercentageConfigViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-18.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "AutocompletionTableView.h"

@interface HYPercentageConfigViewController : HYBaseViewController<UITableViewDataSource,UITableViewDelegate,AutocompletionTableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIButton *uiFixed;
@property (strong, nonatomic) IBOutlet UIButton *uiPercent;
@property (nonatomic, strong) NSMutableArray *dyArray;
@property (strong, nonatomic) IBOutlet UITableViewCell *tabelViewCell;
@property (strong, nonatomic) IBOutlet UIImageView *uibgLabel;
@property (strong, nonatomic) IBOutlet UIImageView *uibgLabel1;


-(IBAction)fixedAction:(id)sender;

-(IBAction)percentAction:(id)sender;

-(IBAction)saveAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *uiModelLabel;

@property (strong, nonatomic) IBOutlet UILabel *uiPercentLabel;

@property (strong, nonatomic) IBOutlet UILabel *uiPercentCellLabel;

@property (strong, nonatomic) IBOutlet UITextField *uiPercentTextField;

@property (strong, nonatomic) IBOutlet UITextField *uiModelTextField;

@property (strong, nonatomic) NSString *percentString;

@end
