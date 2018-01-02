//
//  ChangePWNextViewController.m
//  LouYu
//
//  Created by barby on 2017/8/5.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "ChangePWNextViewController.h"
#import "LoginViewController.h"
@interface ChangePWNextViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *PWtextField;
@property(nonatomic,strong)UITextField *PWSuretextFiled;
@property(nonatomic,strong)UIView *backGroundView;
@property(nonatomic,strong)NSNumber *tokenStr;

@end

@implementation ChangePWNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarButtonItemWithImageName:@"btn_back_normal.80.png" andTitle:@"返回"];
    self.title=@"修改密码";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self addNoticeForKeyboard];
    [self creatView];
    [self getToken];
    
}


-(void)creatView{
    
    self.backGroundView =[[UIView alloc] initWithFrame:CGRectMake(0, 100, KscreenWidth,110 )];
    [self.view addSubview:self.backGroundView];
    
    UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    [textLabel setText:@"请输入新密码:"];
    [textLabel setTextColor:KRGB(134, 136, 148, 1.0)];
    [textLabel setFont: [UIFont systemFontOfSize:14.0f]];
    [self.backGroundView addSubview:textLabel];
    //输入框
    self.PWtextField=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame), textLabel.frame.origin.y, KscreenWidth-textLabel.frame.size.width-35, 30)];
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0,self.PWtextField.frame.size.height-1, self.PWtextField.frame.size.width, 1)];
    [lineView setBackgroundColor:[UIColor blueColor]];
    [self.PWtextField addSubview:lineView];
    [self.PWtextField setDelegate:self];
    [self.PWtextField setSecureTextEntry:YES];
    [self.PWtextField setTextAlignment:NSTextAlignmentLeft];
    [self.PWtextField setFont:[UIFont systemFontOfSize:15.0f]];
    [self.PWtextField setBackgroundColor:[UIColor whiteColor]];
    [self.PWtextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.backGroundView addSubview:self.PWtextField];
    
    
    
    
    UILabel *textLabel2=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(textLabel.frame)+20, 100, 40)];
    [textLabel2 setText:@"再次输入密码:"];
    [textLabel2 setTextColor:KRGB(134, 136, 148, 1.0)];
    [textLabel2 setFont: [UIFont systemFontOfSize:14.0f]];
    [self.backGroundView addSubview:textLabel2];
    //输入框
    self.PWSuretextFiled=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textLabel2.frame), textLabel2.frame.origin.y, KscreenWidth-textLabel.frame.size.width-35, 30)];
    UIView *lineView1=[[UIView alloc] initWithFrame:CGRectMake(0,self.PWSuretextFiled.frame.size.height-1, self.PWSuretextFiled.frame.size.width, 1)];
    [lineView1 setBackgroundColor:[UIColor blueColor]];
    [self.PWSuretextFiled addSubview:lineView1];
    
    [self.PWSuretextFiled setDelegate:self];
    [self.PWSuretextFiled setSecureTextEntry:YES];
    [self.PWSuretextFiled setTextAlignment:NSTextAlignmentLeft];
    [self.PWSuretextFiled setFont:[UIFont systemFontOfSize:15.0f]];
    [self.PWSuretextFiled setBackgroundColor:[UIColor whiteColor]];
    [self.PWSuretextFiled setKeyboardType:UIKeyboardTypeNumberPad];
    [self.backGroundView addSubview:self.PWSuretextFiled];

    
    
    
    
    
    
    UIButton *sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [sureButton setFrame:CGRectMake(80, CGRectGetMaxY(self.backGroundView.frame)+30,KscreenWidth-160, 30)];
    [sureButton setImage:[UIImage imageNamed:@"btn_normal_queding.png"] forState:UIControlStateNormal];
    [sureButton setTintColor:[UIColor whiteColor]];
    [sureButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [sureButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [sureButton addTarget:self action:@selector(sureButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    
    
}
#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (self.backGroundView.frame.origin.y+self.backGroundView.frame.size.height+20) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}


-(void)sureButtonDidPress:(UIButton *)sender{
    
    if ([self.PWtextField.text isEqualToString:self.PWSuretextFiled.text]) {
       [self PostDataToSeverWithUrl:@"http://louyu.qianchengwl.cn/minapp/user/changePassword"];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"你输入的密码不一致"];
        [SVProgressHUD dismissWithDelay:0.5];
         //NSLog(@"你输入的密码不一致");
    
    }
    
}


-(void)getToken{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.tokenStr=userDic[@"token"];
    
    // NSLog(@"self.tokenStr%@",self.tokenStr);
    
}

/**********************上传json到服务器请求数********************************/
-(void)PostDataToSeverWithUrl:(NSString *)Url{
    
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.PWtextField.text forKey:@"password"];
    [HttpRequest POST:Url getToken:self.tokenStr paramentDict:dictionary success:^(id responseObj) {
        
                    //请求成功返回数据；需要转化成字典（即json格式数据）
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        if ([dict[@"code"] isEqualToNumber:@(-1001)]) {
            [ClearCache showHUDWithText:@"该账号已在其他设备登录，请重新登录"];
            LoginViewController *logInCV=[[LoginViewController alloc] init];
            [self presentViewController:logInCV animated:YES completion:nil];
        }
        //                NSLog(@"dict:%@",dict);
        else{
                   // NSLog(@"responseObject:%@",dict);
                    if ([dict[@"code"] isEqualToNumber:@1]) {
                        LoginViewController *LoginCv=[[LoginViewController alloc] init];
                        [self.navigationController presentViewController:LoginCv animated:YES completion:nil];
                    }
                    if([dict[@"code"] isEqualToNumber:@(-4)]){
                        [SVProgressHUD showErrorWithStatus:@"不能与原密码相同，请重新输入"];
                    [SVProgressHUD dismissWithDelay:0.5];
                    }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}












- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (![self.PWtextField isExclusiveTouch]) {
        [self.PWtextField resignFirstResponder];
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.PWtextField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
