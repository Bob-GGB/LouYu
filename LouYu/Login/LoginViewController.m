//
//  LoginViewController.m
//  LouYu
//
//  Created by barby on 2017/7/18.
//  Copyright © 2017年 barby. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import <AFNetworking.h>
#import "HttpRequest.h"

#import "RootTabController.h"
#import <CommonCrypto/CommonDigest.h>
#import <JPUSHService.h>
@interface LoginViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)NSMutableDictionary *userInfoDictionary;
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     [AtuoFillScreenUtils autoLayoutFillScreen:self.view];
    [self addNoticeForKeyboard];
   [self setLoginView];
    
    NSUserDefaults *defaults1=[NSUserDefaults standardUserDefaults];
    [defaults1 removeObjectForKey:@"KcompanyName"];
    [defaults1 removeObjectForKey:@"KcompanyID"];
    [defaults1 removeObjectForKey:@"UserInfoDic"];
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode ==0) {
            iAlias=@"";
        }
    } seq:00];
}

-(void)setLoginView{
    
    
    __weak typeof(self)weakSelf=self;
;
    self.logoImageView=[[UIImageView alloc]init];
//                        WithFrame:CGRectMake(KscreenWidth/2-35,70, 70,70)];
    [self.logoImageView setImage:[UIImage imageNamed:@"icon_louyu.png"]];
    self.logoImageView.clipsToBounds  = YES;
    // 设置圆角的大小
    self.logoImageView.layer.cornerRadius = 5;
    [self.logoImageView.layer setMasksToBounds:YES];
    [self.view addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(KscreenWidth*0.5-35));
        make.top.equalTo(@70);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    //添加显示用于承载用户名和密码输入框
    self.imageView = [[UIImageView alloc]init];
//                              WithFrame:CGRectMake(33, CGRectGetMaxY(self.logoImageView.frame)+61, KscreenWidth-66, 98)];
    //添加边框
    CALayer * layer = [self.imageView  layer];
    layer.borderColor = KRGB(201, 201, 201, 1.0f).CGColor;
    layer.borderWidth = 1.0f;
    // 设置圆角的大小
    [self.imageView  setUserInteractionEnabled:YES];
    self.imageView .layer.cornerRadius = 10;
    [self.imageView.layer setMasksToBounds:YES];

    [self.view addSubview:self.imageView ];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(weakSelf.logoImageView.mas_bottom).offset(61);
        make.size.mas_equalTo(CGSizeMake(KscreenWidth-66, 98));
    }];


    //QQ输入框
    self.userNameTextField=[[UITextField alloc] init];
//                            WithFrame:CGRectMake(0, 0, KscreenWidth-66, 49)];
    [self.userNameTextField setDelegate:self];
    [self.userNameTextField setTextAlignment:NSTextAlignmentLeft];
    [self.userNameTextField setFont:[UIFont systemFontOfSize:15.0f]];
    [self.userNameTextField setPlaceholder:@"  账号"];
    [self.userNameTextField setBackgroundColor:[UIColor whiteColor]];
    [self.userNameTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.imageView addSubview:self.userNameTextField];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@0);
        make.right.equalTo(@-10);
        make.height.equalTo(@49);
    }];

    //密码框
    self.passWordTextField=[[UITextField alloc] init];
//                            WithFrame:CGRectMake(0, CGRectGetMaxY(self.userNameTextField.frame), self.userNameTextField.frame.size.width, 49)];
    [self.passWordTextField setDelegate:self];
    [self.passWordTextField setTextAlignment:NSTextAlignmentLeft];
    [self.passWordTextField setFont:[UIFont systemFontOfSize:15.0f]];
    [self.passWordTextField setPlaceholder:@"  密码"];
    [self.passWordTextField setBackgroundColor:[UIColor whiteColor]];
    [self.passWordTextField setKeyboardType:UIKeyboardTypeAlphabet];
    [self.passWordTextField setSecureTextEntry:YES];
    [self.imageView addSubview:self.passWordTextField];
    [self.passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(weakSelf.userNameTextField.mas_bottom);
        make.right.equalTo(@-10);
        make.height.equalTo(@49);
    }];

   //账号密码框之间的横线---
    UIView *lineView=[[UIView alloc] init];
//                      WithFrame:CGRectMake(0, CGRectGetMaxY(self.userNameTextField.frame)+0.5, imageView.frame.size.width, 1)];
    [lineView setBackgroundColor:KRGB(201, 201, 201, 1.0f)];
    [self.imageView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(weakSelf.userNameTextField.mas_bottom).offset(0.5);
        make.width.equalTo(weakSelf.imageView.mas_width);
        make.height.equalTo(@1);
    }];

    //登陆按钮------
    self.loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [self.loginButton setFrame:CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame)+29,self.passWordTextField.frame.size.width, 49*Height)];
    //[Login setAlpha:0.5];
    [self.loginButton setImage:[UIImage imageNamed:@"btn_denglu.png"] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(buttonTouchEvent:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(imageView.mas_left);
        make.top.equalTo(weakSelf.imageView.mas_bottom).offset(29);
        make.centerX.equalTo(self.view);
        make.width.equalTo(weakSelf.passWordTextField.mas_width);
        make.height.equalTo(@49);
    }];

}



-(void)buttonTouchEvent:(UIButton *)sender{
    
    //1.校验输入
    if (self.userNameTextField.text.length == 0 || self.passWordTextField.text.length == 0) {
        
        NSLog(@"账号或密码不能为空");
            }
    
    else
    {
    [self.view endEditing:YES];
    [self jsonToSever];
        

    }
    
    
}

-(void)jsonToSever{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    [manager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type" ];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
    
    
    /****************************************************************************************/
    
    //获取当前时间
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    NSNumber *userStr = @([self.userNameTextField.text integerValue]);//获取用户输入的账号密码
    NSNumber *passStr =@([self.passWordTextField.text integerValue]);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:userStr forKey:@"mobile"];
    [dictionary setValue:passStr forKey:@"password"];
    
    NSMutableDictionary *Alldict=[[NSMutableDictionary alloc] init];
    [Alldict setValue:dictionary forKey:@"app"];
    [Alldict setValue:@"" forKey:@"token"];
    [Alldict setValue:DateTime forKey:@"timestamp"];
    
    
    //md5加密
    //    //字符串拼接
    
    NSString *MD5String1=[self ziDianZhuanJson:dictionary];
    
    NSString *MD5string2=[NSString stringWithFormat:@"%@%@",[Alldict objectForKey:@"token"],[Alldict objectForKey:@"timestamp"]];
    NSString *MD5Str=[ MD5string2 stringByAppendingString: MD5String1];
    // NSLog(@"hahahah%@",MD5Str);
    //MD5加密
    NSString *getStrMD5=[self encryptStringWithMD5:MD5Str];
    [Alldict setValue:getStrMD5  forKey:@"checksum"];
    
    
    /****************************************************************************************/
    
    //传入的参数
    
    NSDictionary *parameters = @{@"app":dictionary,@"timestamp":DateTime,@"token":@"",@"checksum":getStrMD5};
    
    //讲字典类型转换成json格式的数据，然后讲这个json字符串作为字典参数的value传到服务器
    
    
    
    //接口地址
    //NSString *urlString = @"http://louyu.qianchengwl.cn/minapp/user/login";
    NSString *urlString=@"http://louyu.qianchengwl.cn/minapp/user/login";
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //请求成功返回数据；需要转化成字典（即json格式数据）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"dict:%@",dict);
            self.userInfoDictionary =[NSMutableDictionary dictionaryWithDictionary:dict];
            
            if ([dict[@"code"] isEqualToNumber:@(-2)]) {
             //NSLog(@"账号或密码错误");
                
                [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
                [SVProgressHUD dismissWithDelay:0.5];
            }
            else{
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [SVProgressHUD dismissWithDelay:0.5];
                //保存服务器返回用户数据到本地
                [self saveUserInfo];
                
                RootTabController *rootCV=[[RootTabController alloc] init];
                [self presentViewController:rootCV animated:YES completion:nil];
            
            
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
            
           
            
        }];


}


//转成json字符串
-(NSString *)ziDianZhuanJson:(NSDictionary *)object{
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        NSLog(@"________Got an error________: %@", error);
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }


    //去掉字符串中的空格
    jsonString = [jsonString stringByReplacingOccurrencesOfString: @" " withString: @""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString: @"\n" withString: @""];
    
    return jsonString;
}

//MD5加密
-(NSString *)encryptStringWithMD5:(NSString *)inputStr{
    const char *newStr = [inputStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(newStr,(unsigned int)strlen(newStr),result);
    NSMutableString *outStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0;i<CC_MD5_DIGEST_LENGTH;i++){
        [outStr appendFormat:@"%02x",result[i]];//注意：这边如果是x则输出32位小写加密字符串，如果是X则输出32位大写字符串
    }
    return outStr;
}


#pragma --将用户信息存储到本地
-(void)saveUserInfo{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.userInfoDictionary forKey:@"UserInfoDic"];
    //保存到本地
    [defaults synchronize];
    
    
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    //绑定alias，用于消息推送
    NSString *alias=[NSString stringWithFormat:@"%@",userDic[@"userID"]];
    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode == 0) {//对应的状态码返回为0，代表成功
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
            NSLog(@"---rescode: %ld, \niAlias: %@, \nseq: %ld\n", (long)iResCode,iAlias, (long)seq);
        }
    } seq:00];
 
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
    CGFloat offset = (self.imageView.frame.origin.y+self.imageView.frame.size.height+100) - (self.view.frame.size.height - kbHeight);
    
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
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
