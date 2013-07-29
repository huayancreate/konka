//
//  HYPasswordConfigViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-19.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYTableViewCell.h"

@interface HYPasswordConfigViewController : HYBaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,HYTableViewCell>
{
}

@property (strong, nonatomic) IBOutlet UITableView *mainTabelView;
@property (strong, nonatomic) UITextField *uinewpassword;
@property (strong, nonatomic) UITextField *uirepeatpassword;
@property (strong, nonatomic) IBOutlet UIImageView *uibgLabel;

@end
