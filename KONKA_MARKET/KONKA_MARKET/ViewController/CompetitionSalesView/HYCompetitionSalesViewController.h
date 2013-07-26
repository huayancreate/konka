//
//  HYCompetitionSalesViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-17.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYTableViewCell.h"
#import "AutocompletionTableView.h"

@interface HYCompetitionSalesViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HYTableViewCell,AutocompletionTableViewDelegate>{

}

// Handles UIControlEventEditingDidEndOnExit
- (IBAction)textFieldFinished:(id)sender ;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

- (IBAction)hisAction:(id)sender;

@end
