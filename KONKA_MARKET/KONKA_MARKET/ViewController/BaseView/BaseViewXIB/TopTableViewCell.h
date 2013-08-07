//
//  TopTableViewCell.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-18.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopTabelViewCell <NSObject>

-(IBAction)upMoth:(id)sender;

-(IBAction)downMoth:(id)sender;

-(IBAction)upYear:(id)sender;

-(IBAction)downYear:(id)sender;

-(IBAction)dataPick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *dateBtn;

@property (strong, nonatomic) IBOutlet UITableViewCell *tableViewCell;

@end

@interface TopTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITableViewCell *tableViewCell;

@property (strong, nonatomic) IBOutlet UIButton *dateBtn;

-(IBAction)upMoth:(id)sender;

-(IBAction)downMoth:(id)sender;

-(IBAction)upYear:(id)sender;

-(IBAction)downYear:(id)sender;

-(IBAction)dataPick:(id)sender;

@end
