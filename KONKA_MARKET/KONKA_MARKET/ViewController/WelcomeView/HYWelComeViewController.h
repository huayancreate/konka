//
//  HYViewController.h
//  KONKA_MARKET
//
//  Created by 许 玮 on 13-12-2.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYWelComeViewController : HYBaseViewController

@property (strong, nonatomic) UIImageView *defaultView;
@property (strong, nonatomic) UIImageView *versionView;
@property (strong, nonatomic) UILabel *lblTips;
@property (strong, nonatomic) UILabel *lblVersion;
@property (strong, nonatomic) UIButton *btnSkip;
@property (strong, nonatomic) UIImage *skipImage;
@property (strong, nonatomic) NSTimer *timer;



@end
