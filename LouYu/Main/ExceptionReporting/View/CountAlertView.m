//
//  GxqBackgroundView.m
//  自定义弹出框
//
//  Created by 高盛通 on 16/2/16.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "CountAlertView.h"
#define screenH  [UIScreen mainScreen].bounds.size.height
#define screenW  [UIScreen mainScreen].bounds.size.width
@implementation CountAlertView

+ (void)showWithImages:(NSString *)images descText:(NSString *)descText LeftText:(NSString *)leftText second:(NSInteger)seconds rightText:(NSString *)rightText LeftBlock:(GxqLeftBlock)leftBlock RightBlock:(GxqRightBlock)rightBlock
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CountAlertView *selfView = [[self alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    selfView.backgroundColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1];
    selfView.backgroundColor=[UIColor grayColor];
//    selfView.alpha = 0.8;
    [keyWindow addSubview:selfView];
    
    //弹出框
    [selfView contentViewWithImages:(NSString *)images descText:descText LeftText:leftText second:seconds rightText:rightText leftBlock:leftBlock RightBlock:rightBlock];
}

+ (void)dismiss
{
    
}

- (void)contentViewWithImages:(NSString *)img descText:(NSString *)descText LeftText:(NSString *)leftText second:(NSInteger)seconds rightText:(NSString *)rightText leftBlock:(GxqLeftBlock)leftBlock RightBlock:(GxqRightBlock)rightBlock
{
    self.leftBlock = leftBlock;
    self.rightBlock = rightBlock;
    self.seconds = seconds + 1;
    CGFloat alertViewW = screenW * 0.68;
    CGFloat alertViewH = 200*Height;
    UIView *alertView = [UIView new];
    
    alertView.alpha = 1.0;
    alertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.0f animations:^{
        alertView.alpha = 1.0;
        alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];

    
    alertView.frame = CGRectMake((screenW - alertViewW) * 0.5, (screenH - alertViewH) * 0.5, alertViewW, alertViewH);
    alertView.backgroundColor = [UIColor whiteColor];
    [self addSubview:alertView];
    
    UIImageView *images=[[UIImageView alloc] init];
    images.frame=CGRectMake(alertView.frame.size.width/2-20, 20, 40*Width, 60*Height);
   // [images setBackgroundColor:[UIColor redColor]];
    [images setImage:[UIImage imageNamed:img]];
    
    
    //设置动画
    if (seconds>0) {
     NSMutableArray *imagesArr=[NSMutableArray array];
    for (int i=0; i<15; i++) {
        //将图片存入数组
        NSString * string = [NSString stringWithFormat:@"record_animate_0%d",i];
        UIImage * image = [UIImage imageNamed:string];
        [imagesArr addObject:image];
        
    }
        //NSLog(@"%@",imagesArr)
    images.animationImages=imagesArr;
    
    images.animationDuration =seconds;
    // repeat the annimation forever
    images.animationRepeatCount = 1;
    // start animating
    [images startAnimating];
        [imagesArr removeAllObjects];
    }
    else{
        [images setImage:[UIImage imageNamed:@"record_animate_00"]];
    }
    // add the animation view to the main window
    [alertView addSubview:images];
    
    
    UILabel *descLabel = [UILabel new];
    descLabel.frame = CGRectMake(0, CGRectGetMaxY(images.frame), alertView.frame.size.width, 30*Height);
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.text = descText;
    
    if (seconds>0) {
        descLabel.textColor=[UIColor redColor];
    }
    else{
    descLabel.textColor=[UIColor grayColor];
    }
    descLabel.font = [UIFont systemFontOfSize:14];
    self.deLabel=descLabel;
    [alertView addSubview:descLabel];

    if (seconds>0) {
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(btnChange:) userInfo:nil repeats:YES];
        _timer = timer;
        [timer fire];
    }
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake((screenW - alertViewW)*0.22 , CGRectGetMaxY(descLabel.frame)+10*Height, alertViewW*0.35, 40*Height);
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:leftText forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn.layer setMasksToBounds:YES];
    [sureBtn.layer setCornerRadius:5];
    [sureBtn setBackgroundColor:KRGB(255, 215, 0, 1.0)];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.sureButton=sureBtn;
    [alertView addSubview:sureBtn];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(sureBtn.frame)+20*Width, sureBtn.frame.origin.y, alertViewW*0.35, 40*Height);
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     [cancelBtn setTitle:rightText forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn.layer setMasksToBounds:YES];
    [cancelBtn.layer setCornerRadius:5];
    [cancelBtn setBackgroundColor:KRGB(255, 215, 0, 1.0)];
    [alertView addSubview:cancelBtn];
}

- (void)sureBtnClick:(UIButton *)btn
{
    //NSLog(@"点击了确定按钮");
    //NSLog(@"btntext:%@",self.sureButton.titleLabel.text);
    if ([self.sureButton.titleLabel.text isEqualToString:@"开始"]) {
        self.leftBlock();
        [self closeView];
    }
    else if([self.sureButton.titleLabel.text isEqualToString:@"停止"]){
    
        self.leftBlock();
        [self closeView];
    }
    else{
    self.leftBlock();
    }
    
}

- (void)cancelBtnClick:(UIButton *)btn
{
    //NSLog(@"点击了取消钮");
    self.rightBlock();
    [self closeView];
}

- (void)btnChange:(UIButton *)btn
{
    _seconds--;
    //    [_leftBtn setTitle:[NSString stringWithFormat:@"取消(%zds)",_seconds] forState:UIControlStateNormal];
    _deLabel.text = [NSString stringWithFormat:@"%@%zd",@"00:",_seconds];
    if (_seconds == 0) {
        [_timer invalidate];
        [self closeView];
        //self.rightBlock();
  }
}


-(void)closeView
{
    [UIView animateWithDuration:0.0f animations:^{
        [self.subviews objectAtIndex:0].alpha = 0;
        [self.subviews objectAtIndex:0].transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)setAnimationImages:(UIImage *)img{


}
@end
