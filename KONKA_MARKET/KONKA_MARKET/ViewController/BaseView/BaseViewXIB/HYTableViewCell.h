//
//  HYTableViewCell.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-18.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYTableViewCell <NSObject>
@property (strong, nonatomic) IBOutlet UILabel *cellLabel;
@property (strong, nonatomic) IBOutlet UITextField *cellTextField;
@property (strong, nonatomic) IBOutlet UITableViewCell *LabelTextTableViewCell;
@property (strong, nonatomic) IBOutlet UIImageView *cellImage;
@property (strong, nonatomic) IBOutlet UILabel *cellLabel1;
@property (strong, nonatomic) IBOutlet UILabel *cellLabel2;
@property (strong, nonatomic) IBOutlet UILabel *cellLabel3;
@end

@interface HYTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellLabel;
@property (strong, nonatomic) IBOutlet UITextField *cellTextField;
@property (strong, nonatomic) IBOutlet UITableViewCell *LabelTextTableViewCell;
@property (strong, nonatomic) IBOutlet UIImageView *cellImage;
@property (strong, nonatomic) IBOutlet UILabel *cellLabel1;
@property (strong, nonatomic) IBOutlet UILabel *cellLabel2;
@property (strong, nonatomic) IBOutlet UILabel *cellLabel3;
@end
