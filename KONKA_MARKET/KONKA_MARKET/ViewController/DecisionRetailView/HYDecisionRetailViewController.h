//
//  HYDecisionRetailViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-9-22.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYDecisionRetailViewController : HYBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *uiNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *uiDetailNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *uiImage;
@property (nonatomic, strong) IBOutlet UITableView *mainTableView;

@end
