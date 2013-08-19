//
//  HYCustomManageViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-8-16.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYCustomManageViewController : HYBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblR3Name;
@property (strong, nonatomic) IBOutlet UILabel *lblR3Code;
@property (strong, nonatomic) IBOutlet UILabel *lblDeptName;
@property (strong, nonatomic) IBOutlet UILabel *lblYwyName;
@property (strong, nonatomic) IBOutlet UILabel *lblType;

@property (strong, nonatomic) IBOutlet UILabel *lblHostName;
@property (strong, nonatomic) IBOutlet UILabel *lblLinkManMobile;
@property (strong, nonatomic) IBOutlet UILabel *lblLinkManAddr;
@property (strong, nonatomic) IBOutlet UILabel *lbllinkManTel;
@property (strong, nonatomic) IBOutlet UILabel *lblLinkManName;
@property (strong, nonatomic) IBOutlet UILabel *lblLinkManPost;

@property (nonatomic, retain) HYUserLoginModel *userlogin;
@property (strong, nonatomic) NSMutableArray *customList;

@property (weak, nonatomic) IBOutlet UITableView *uiTableView;

@end
