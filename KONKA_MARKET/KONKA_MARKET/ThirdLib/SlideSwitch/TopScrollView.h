//
//  TopScrollView.h
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYUserLoginModel.h"

@interface TopScrollView : UIScrollView <UIScrollViewDelegate>
{
    NSArray *nameArray;
    NSArray *idArray;
    NSInteger userSelectedChannelID;        //点击按钮选择名字ID
    NSInteger scrollViewSelectedChannelID;  //滑动列表选择名字ID
    
    UIImageView *shadowImageView;
}
@property (nonatomic, retain) NSArray *nameArray;
@property (nonatomic, retain) NSArray *idArray;
@property (nonatomic, assign) NSInteger scrollViewSelectedChannelID;
@property (nonatomic, retain) HYUserLoginModel *userlogin;
@property (strong, nonatomic) UINavigationController *linkNav;

+ (TopScrollView *)shareInstance:(NSString *)username Password:(NSString *)password Nav:(UINavigationController *)navController;
//滑动撤销选中按钮
- (void)setButtonUnSelect;
//滑动选择按钮
- (void)setButtonSelect;

@end
