//
//  TopScrollView.h
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopScrollView : UIScrollView <UIScrollViewDelegate>
{
    NSArray *nameArray;
    NSInteger userSelectedChannelID;        //点击按钮选择名字ID
    NSInteger scrollViewSelectedChannelID;  //滑动列表选择名字ID
    
    UIImageView *shadowImageView;
}
@property (nonatomic, retain) NSArray *nameArray;
@property (nonatomic, assign) NSInteger scrollViewSelectedChannelID;

+ (TopScrollView *)shareInstance;
//滑动撤销选中按钮
- (void)setButtonUnSelect;
//滑动选择按钮
- (void)setButtonSelect;

@end
