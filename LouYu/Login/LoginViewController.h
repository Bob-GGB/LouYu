//
//  LoginViewController.h
//  LouYu
//
//  Created by barby on 2017/7/18.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property(nonatomic,strong)UIImageView *logoImageView;
@property(nonatomic,strong)UITextField *userNameTextField;
@property(nonatomic,strong)UITextField *passWordTextField;
@property(nonatomic,strong)UIButton *loginButton;

//保存服务器返回的用户数据到本地
-(void)saveUserInfo;



@end
