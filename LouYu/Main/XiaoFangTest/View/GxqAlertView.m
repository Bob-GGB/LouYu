//
//  GxqBackgroundView.m
//  自定义弹出框
//
//  Created by 高盛通 on 16/2/16.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "GxqAlertView.h"
#define screenH  [UIScreen mainScreen].bounds.size.height
#define screenW  [UIScreen mainScreen].bounds.size.width
@implementation GxqAlertView

+ (void)showWithTipText:(NSString *)tipText second:(NSInteger)seconds rightText:(NSString *)rightText RightBlock:(GxqRightBlock)rightBlock TimeOver:(TimeOverBlock)timeOverBlock
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    GxqAlertView *selfView = [[self alloc]initWithFrame:[UIScreen mainScreen].bounds];
    selfView.backgroundColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1];
    //selfView.alpha = 0.2;
    [keyWindow addSubview:selfView];
    
    //弹出框
    [selfView contentViewWithTipText:tipText second:seconds rightText:rightText  RightBlock:rightBlock TimeOver:timeOverBlock];
}

+ (void)dismiss
{
    
}

- (void)contentViewWithTipText:(NSString *)tipText second:(NSInteger)seconds rightText:(NSString *)rightText RightBlock:(GxqRightBlock)rightBlock TimeOver:(TimeOverBlock)timeOverBlock
{
    self.rightBlock = rightBlock;
    self.timeOverBlock = timeOverBlock;
    self.seconds = seconds + 1;
    CGFloat alertViewW = screenW * 0.68;
    CGFloat alertViewH = 200*Height;
    UIView *alertView = [UIView new];
    
    alertView.alpha = 0;
    alertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.25f animations:^{
        alertView.alpha = 1.0;
        alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];

    
    alertView.frame = CGRectMake((screenW - alertViewW) * 0.5, (screenH - alertViewH) * 0.5, alertViewW, alertViewH);
    alertView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    [self addSubview:alertView];
    
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.frame = CGRectMake(0, 0, alertView.frame.size.width, 40*Height);
    tipLabel.text = tipText;
    tipLabel.backgroundColor=KRGB(30, 144, 255, 1.0);
    [tipLabel setTextColor:[UIColor whiteColor]];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    
    [alertView addSubview:tipLabel];
    
    UILabel *descLabel = [UILabel new];
    descLabel.frame = CGRectMake(0, 60*Width, alertView.frame.size.width, 30);
    descLabel.textAlignment = NSTextAlignmentCenter;
    //descLabel.text = leftText;
    descLabel.font = [UIFont systemFontOfSize:25];
    self.descTextLabel=descLabel;
    [alertView addSubview:descLabel];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.frame = CGRectMake(alertView.frame.size.width/4 + 20, CGRectGetMaxY(descLabel.frame)+10, self.frame.size.width / 2 - 5, 20);
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.text = @"5秒后自动返回";
    [alertView addSubview:timeLabel];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(btnChange:) userInfo:nil repeats:YES];
    _timer = timer;
    [timer fire];
    
    UIButton *sureBtn = [UIButton new];
    sureBtn.frame = CGRectMake(alertView.frame.size.width/2-alertView.frame.size.width / 4,alertView.frame.size.height-60 , alertView.frame.size.width / 2, 40);
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:rightText forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithRed:0.19 green:0.62 blue:0.78 alpha:1] forState:UIControlStateNormal];
    [sureBtn.layer setBorderColor:[UIColor colorWithRed:0.19 green:0.62 blue:0.78 alpha:1].CGColor];
    [sureBtn.layer setBorderWidth:1];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [alertView addSubview:sureBtn];
    
    
//    UIButton *cancelBtn = [UIButton new];
//    cancelBtn.frame = CGRectMake(0, 100, alertView.frame.size.width * 0.5, 40);
//    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    cancelBtn.backgroundColor = [UIColor clearColor];
//    [alertView addSubview:cancelBtn];
}

- (void)sureBtnClick:(UIButton *)btn
{
   // NSLog(@"点击了确定按钮");
    self.rightBlock();
    [self closeView];
}

//- (void)cancelBtnClick:(UIButton *)btn
//{
//    NSLog(@"点击了取消按钮");
//    self.leftBlock();
//    [self closeView];
//}

- (void)btnChange:(UIButton *)btn
{
    _seconds--;
    //    [_leftBtn setTitle:[NSString stringWithFormat:@"取消(%zds)",_seconds] forState:UIControlStateNormal];
    _descTextLabel.text = [NSString stringWithFormat:@"%zd",_seconds];
    if (_seconds == 0) {
        [_timer invalidate];
        self.timeOverBlock();
        [self timeOverBlock];
        [self closeView];
        [self rightBlock];
       
        
  }
}


-(void)closeView
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.subviews objectAtIndex:0].alpha = 0;
        [self.subviews objectAtIndex:0].transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
