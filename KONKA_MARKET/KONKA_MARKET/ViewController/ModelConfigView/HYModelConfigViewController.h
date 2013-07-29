//
//  HYModelConfigViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-17.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "AutocompletionTableView.h"

@interface HYModelConfigViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,AutocompletionTableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView *modelConfigTableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *tableViewCell;

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) IBOutlet UIButton *uiModelSet;

@property (strong, nonatomic) IBOutlet UIButton *uiUnModelSet;

@property (strong, nonatomic) IBOutlet UILabel *uiLableModelName;

@property (strong, nonatomic) IBOutlet UIButton *uiSearchBtn;

@property (strong, nonatomic) IBOutlet UIButton *uiSetModelBtn;

@property (strong, nonatomic) IBOutlet UILabel *uiCancelModelLabel;
-(IBAction)modelSetAction:(id)sender;

-(IBAction)unmModelSetAction:(id)sender;

-(IBAction)setDefaultModel:(id)sender;

-(IBAction)unSetDefaultModel:(id)sender;

-(IBAction)search:(id)sender;

-(IBAction)up:(id)sender;

-(IBAction)down:(id)sender;

@end
