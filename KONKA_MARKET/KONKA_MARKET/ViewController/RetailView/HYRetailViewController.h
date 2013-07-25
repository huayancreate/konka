//
//  HYRetailViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-4.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYRetailViewController : HYBaseViewController<UITableViewDataSource,UITableViewDelegate>


-(IBAction)dataSubmit:(id)sender;


-(IBAction)salesSubmit:(id)sender;

-(IBAction)competitionsSales:(id)sender;

-(IBAction)salesComputations:(id)sender;

-(IBAction)percentageAction:(id)sender;

-(IBAction)modelConfigAction:(id)sender;
@end
