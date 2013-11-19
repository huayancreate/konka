//
//  HYSystemConfigViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-9.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "Harpy.h"

@interface HYSystemConfigViewController : HYBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) NSDictionary *resource;

@property (nonatomic,retain) NSArray *mykey;

@property (strong, nonatomic) IBOutlet UITableView *tableViewGroup;

@property (strong, nonatomic) IBOutlet UIImageView *uibgLabel;

@end
