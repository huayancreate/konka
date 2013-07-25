//
//  HYModelConfigViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-17.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "AutocompletionTableView.h"

@interface HYModelConfigViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,AutocompletionTableViewDelegate>

@property (nonatomic,strong) UITableView *modelConfigTableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *tableViewCell;

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) IBOutlet UIButton *uiModelSet;

@property (strong, nonatomic) IBOutlet UIButton *uiUnModelSet;

@property (strong, nonatomic) IBOutlet UILabel *uiLableModelName;

-(IBAction)modelSetAction:(id)sender;

-(IBAction)unmModelSetAction:(id)sender;
@end
