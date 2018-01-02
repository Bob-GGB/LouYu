//
//  GxqBackgroundView.h
//  自定义弹出框
//
//  Created by 高盛通 on 16/2/16.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GxqAlertView : UIView
typedef void (^TimeOverBlock)(void);
typedef void (^GxqRightBlock)(void);
@property (nonatomic,copy)TimeOverBlock timeOverBlock;
@property (nonatomic,copy)GxqRightBlock rightBlock;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger seconds;
@property (nonatomic,strong)UILabel *descTextLabel;
+ (void)showWithTipText:(NSString *)tipText second:(NSInteger)seconds rightText:(NSString *)rightText RightBlock:(GxqRightBlock)rightBlock TimeOver:(TimeOverBlock)timeOverBlock;
@end
